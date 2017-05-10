//
//  ViewController.swift
//  Calculator
//
//  Created by Dirk Hornung on 5/5/17.
//  Copyright © 2017 Dirk Hornung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping : Bool = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "us") // will set the separator to "." instead of the GER ","
            formatter.maximumFractionDigits = 6
            formatter.numberStyle = NumberFormatter.Style.decimal
            display.text = formatter.string(from: NSNumber(value: newValue))
        }
    }
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if(digit != "." || textCurrentlyInDisplay.range(of: ".") == nil) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func eraseDigit(_ sender: UIButton) {
        var textCurrentlyInDisplay = display.text!
        switch textCurrentlyInDisplay.characters.count {
        case let x where x > 1:
            textCurrentlyInDisplay.remove(at: textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex))
            display.text = textCurrentlyInDisplay
        case let x where x == 1:
            display.text = "0"
        default:
            break
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        descriptionDisplay.text = brain.getDescription
    }
    
}

