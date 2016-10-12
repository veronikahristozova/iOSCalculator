//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Veronika Hristozova on 10/3/16.
//  Copyright © 2016 Veronika Hristozova. All rights reserved.
//

import Foundation

func divide(op1 : Double, op2 : Double) -> Double {
    if op2 == 0 {
        return 0
    } else {
        return op1/op2
    }
}

enum Operation {
    case Constant(Double)
    case UnaryOperation((Double)->Double)
    case BinaryOperation((Double, Double) -> Double)
    case Equals
    case Clear
}

struct PendingBinaryOperationInfo {
    var binaryFunction: (Double, Double) -> Double
    var firstOperand: Double
}

class CalculatorBrain
{
    typealias PropertyList = AnyObject
    private var pending: PendingBinaryOperationInfo?
    
    var accumulator: Double = 0
    var result: Double { get { return accumulator } }
    var internalProgram = [AnyObject]()
    var program: PropertyList {
        get { return internalProgram as CalculatorBrain.PropertyList }
        set {
            accumulator = 0
            pending = nil
            internalProgram.removeAll()
            
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0*$1 }),
        "÷" : Operation.BinaryOperation(divide),
        "+" : Operation.BinaryOperation({ $0+$1 }),
        "−" : Operation.BinaryOperation({ $0-$1 }),
        "=" : Operation.Equals,
        "C" : Operation.Clear
    ]
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation  {
            case .Constant(let value) :
                accumulator = value
            case .UnaryOperation(let function) : accumulator = function(accumulator)
            case .BinaryOperation(let function) :
                executingPendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals : executingPendingBinaryOperation()
            case .Clear :
                internalProgram.removeAll()
                pending = nil
                accumulator = 0
            }
        }
    }
    
    private func executingPendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
