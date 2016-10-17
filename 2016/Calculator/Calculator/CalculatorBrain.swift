//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by John Lima on 13/10/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import Foundation

enum Optional<T> {
    case None
    case Some(T)
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var pending: PendingBinaryOperationInfo?
    
    var result: Double {
        get {return self.accumulator}
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "x": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func set(operand: Double) {
        self.accumulator = operand
    }
    
    func performOperation(symbol: String) {
        if let operation = self.operations[symbol] {
            switch operation {
            case .Constant(let value):
                self.accumulator = value
            case .UnaryOperation(let function):
                self.accumulator = function(accumulator)
            case .BinaryOperation(let function):
                self.executePendingBinaryOperation()
                self.pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: self.accumulator)
            case .Equals:
                self.executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if self.pending != nil {
            self.accumulator = self.pending!.binaryFunction(self.pending!.firstOperand, self.accumulator)
            self.pending = nil
        }
    }
    
}
