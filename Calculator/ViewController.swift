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
    var dotTypped = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping { displayValue.appendDigit(digit: dotTypped ? ".\(digit)" : digit) }
        else { displayValue = Double(digit) ?? 0 }
        userIsInTheMiddleOfTyping = true
        dotTypped = digit == "."
    }
    
    var displayValue : Double = 0 { didSet { display.text = displayValue.decimalFormatted } }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
   
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain()
    
    
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
    
    @IBAction func swipeToDelete(_ sender: UISwipeGestureRecognizer) {
        deleteLastDigit()
    }
    
    private func deleteLastDigit() {
        if displayValue != 0 {
            displayValue.removeDigit()
        }
    }
}
