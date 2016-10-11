//
//  ViewController.swift
//  Calculator
//
//  Created by Veronika Hristozova on 10/3/16.
//  Copyright © 2016 Veronika Hristozova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var savedProgram: CalculatorBrain.PropertyList?
    private var brain = CalculatorBrain()
    
    var displayValue : Double {
        get {
            return convertStringToDouble(decimalAsString: display.text!)
        }
        set {
            let a = newValue.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(newValue)) : String(newValue)
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .decimal
//            formatter.string(from: NSNumber(value: Double(a)!))
//            display.text?.replacingOccurrences(of: ",", with: "")
            display.text = a
        }
    }
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let currentlyInDislay = display.text!
            display.text = currentlyInDislay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func save() {
        savedProgram = brain.program
    }
   
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    func convertStringToDouble(decimalAsString: String) -> Double {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        var decimalAsDouble = formatter.number(from: decimalAsString)?.doubleValue
        if let decimalAsDoubleUnwrapped = formatter.number(from: decimalAsString) {
            decimalAsDouble = decimalAsDoubleUnwrapped.doubleValue
        }
        return decimalAsDouble!
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        
    }
}
