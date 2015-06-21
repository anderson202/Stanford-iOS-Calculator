//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Anderson Ng on 2015-06-13.
//  Copyright (c) 2015 Anderson Ng. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op:Printable{
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description:String{
        get{
            switch self{
            case .Operand(let operand):
                return "\(operand)"
            case .Variable(let symbol):
                return symbol
            case .UnaryOperation(let symbol, _):
                return symbol
            case BinaryOperation(let symbol, _):
                return symbol
        
            }
        }
        
    }

    }
    private var opStack = [Op]()
    
    var variableValues = [String:Double]()
    
    private var knownOps = [String:Op]()
    
    init(){
        knownOps["+"] = Op.BinaryOperation("+",+)
        knownOps["−"] = Op.BinaryOperation("−"){$1-$0}
        knownOps["×"] = Op.BinaryOperation("×",*)
        knownOps["÷"] = Op.BinaryOperation("÷"){$1/$0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin",sin)
        knownOps["cos"] = Op.UnaryOperation("cos",cos)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case Op.Operand(let operand):
                return (operand, remainingOps)
            case Op.UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case Op.BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case Op.Variable(let variable):
                if let valueOfVariable = variableValues[variable]{
                    return (valueOfVariable, remainingOps)
                }
                return (nil, remainingOps)
                
            }
        }
        return (nil, ops)
    }
    
    var description:String{
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }

    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol:String) -> Double?{
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String )->Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear(){
        opStack = []
    }
    
        
    
    
}

