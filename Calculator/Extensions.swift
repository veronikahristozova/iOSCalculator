//
//  Extensions.swift
//  Calculator
//
//  Created by Gavril Tonev on 10/11/16.
//  Copyright © 2016 Veronika Hristozova. All rights reserved.
//

import Foundation

// MARK: Decimal Formatting of Double
extension Double {
    
    mutating func appendDigit(digit: String) {
        let truncatedValue = self.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(self)) : String(self)
        if let k = Double("\(truncatedValue)\(digit)") { self = k }
    }
    
    mutating func removeDigit() {
        var truncatedValue = self.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(self)) : String(self)
        if !truncatedValue.isEmpty {
            truncatedValue = truncatedValue.substring(to: truncatedValue.index(before: truncatedValue.endIndex))
            if let k = Double("\(truncatedValue)") { self = k }
        }
    }
    
    var decimalFormatted: String {
        get {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 10
            let formattedValue = formatter.string(for: self)!
            
            return formattedValue
        }
    }
}
