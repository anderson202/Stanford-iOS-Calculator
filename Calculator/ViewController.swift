//
//  ViewController.swift
//  Calculator
//
//  Created by Anderson Ng on 2015-06-11.
//  Copyright (c) 2015 Anderson Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var display2: UILabel!
    
    var userIsEnteringDigit = false
    
    var brain = CalculatorBrain()
    
    
    @IBAction func appendDecimal() {
        if display.text!.rangeOfString(".") == nil {
            display.text! += "."
        }
        else if !userIsEnteringDigit{
            display.text! = "0."
        }
        userIsEnteringDigit = true

    }
    
    
    @IBAction func appendAll(sender: UIButton) {
        var input = sender.currentTitle!
        display2.text! += input
        
    }
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if userIsEnteringDigit{
            display.text! += digit
        }
        else{
            display.text! = digit
            userIsEnteringDigit = true
        }
    }
    
    @IBAction func appendPi() {
        brain.pushOperand(M_PI)
    }
    
   
    @IBAction func operate(sender: UIButton) {
        if (userIsEnteringDigit){
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else{
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsEnteringDigit = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        }
        else{
            displayValue = 0
        }
        
    }
    
    var displayValue: Double?{
        get{
            if let dValue = NSNumberFormatter().numberFromString(display.text!)?.doubleValue{
                return dValue
            }
            return nil
        }
        set{
            display.text = newValue != nil ? "\(newValue!)":" " //if display.text is equal to newValue but not nil, then go with newvalue, if not return 0
            userIsEnteringDigit = false
        }
    }
    
    @IBAction func Clear() {
        brain.clear()
        displayValue = 0
        display.text! = "0"
        userIsEnteringDigit = false
        display2.text! = "last: "
    }
    
    
    @IBAction func backspace() {
        if userIsEnteringDigit && countElements(display.text!) == 1{
            display.text! = "0"
            userIsEnteringDigit = false
        }
        else if userIsEnteringDigit && !display.text!.isEmpty{
            display.text! = dropLast(display.text!)
        }
    }
}

