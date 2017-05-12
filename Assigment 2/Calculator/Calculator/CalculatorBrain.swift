//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Dirk Hornung on 6/5/17.
//  Copyright © 2017 Dirk Hornung. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    private var internalProgram = [String]()
    private var descriptionAccumulator = " "
    private var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    var description: String {
        get {
            if !isPartialResult {
                return descriptionAccumulator
            } else {
                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
            }
        }
    }
    
    var getDescription: String {
        get {
            if(description != " ") {
                return isPartialResult ? (description + "...") : (description + "=")
            } else {
                return " "
            }
            
        }
    }
    
    var variableValues = [String: Double]()
    
    func setOperand(_ variableName: String) {
        internalProgram.append(variableName)
    }
    
    func setOperand(_ operand: Double) {
        internalProgram.append(String(operand))
    }

    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "🚀" : Operation.Constant(42.0),
        "?" : Operation.NullaryOperation({ Double(arc4random())/4294967295 }),
        "√" : Operation.UnaryOperation(sqrt, { "√(\($0))" }),
        "sin" : Operation.UnaryOperation(sin, { "sin(\($0))" }),
        "cos" : Operation.UnaryOperation(cos, { "cos(\($0))" }),
        "tan" : Operation.UnaryOperation(tan, { "tan(\($0))" }),
        "x⁻¹" : Operation.UnaryOperation({ 1/$0 }, { "(\($0))⁻1"}),
        "x²" : Operation.UnaryOperation({ $0 * $0 }, { "(\($0))²"}),
        "x³" : Operation.UnaryOperation({ $0 * $0 * $0 }, { "(\($0))³"}),
        "+" : Operation.BinaryOperation({ $0 + $1 }, { "\($0)+\($1)" }, OperationPriority.Low),
        "-" : Operation.BinaryOperation({ $0 - $1 }, { "\($0)-\($1)" }, OperationPriority.Low),
        "×" : Operation.BinaryOperation({ $0 * $1 }, { "\($0)×\($1)" }, OperationPriority.High),
        "÷" : Operation.BinaryOperation({ $0 / $1 }, { "\($0)÷\($1)" }, OperationPriority.High),
        "%" : Operation.BinaryOperation({ $0.truncatingRemainder(dividingBy: $1)}, { "\($0)%\($1)" }, OperationPriority.High),
        "=" : Operation.Equals,
        "C" : Operation.Clear
    ]
    
    private enum OperationPriority: Int {
        case Low = 0, High = 1
    }
    private var currentPriority = OperationPriority.Low
    
    private enum Operation {
        case Constant(Double)
        case NullaryOperation(() -> Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, OperationPriority)
        case Clear
        case Equals
    }
    
    func addOperation(_ symbol: String) {
        internalProgram.append(symbol)
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                descriptionAccumulator = symbol
                accumulator = value
            case .NullaryOperation(let rand):
                accumulator = rand()
                descriptionAccumulator = "rand"
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let OperationPriority):
                executePendingBinaryOperation()
                if(currentPriority.rawValue < OperationPriority.rawValue) {
                    descriptionAccumulator = "(\(descriptionAccumulator))"
                }
                currentPriority = OperationPriority;
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    func clear() {
        accumulator = 0
        descriptionAccumulator = " "
        pending = nil
        internalProgram.removeAll()
        variableValues.removeAll()
    }
    
    func undo() {
        internalProgram.removeLast()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String) {
            if variables != nil {
                variableValues = variables!
            }
            self.accumulator = 0
            self.descriptionAccumulator = " "
            pending = nil
            print("----")
            for entry in internalProgram {
                print(entry)
                if let operand = Double(entry) {
                    let formatter = NumberFormatter()
                    formatter.locale = Locale(identifier: "us") // will set the separator to "." instead of the GER ","
                    formatter.maximumFractionDigits = 6
                    formatter.numberStyle = NumberFormatter.Style.decimal
                    descriptionAccumulator = formatter.string(from: NSNumber(value: operand))!
                    accumulator = operand
                } else if let operation = operations[entry] {
                    performOperation(entry)
                } else {
                    accumulator = variableValues[entry] ?? 0.0
                    descriptionAccumulator = entry
                }
            }
            return (accumulator, isPartialResult, getDescription)
    }
}
