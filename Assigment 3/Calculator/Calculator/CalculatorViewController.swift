//
//  ViewController.swift
//  Calculator
//
//  Created by Dirk Hornung on 5/5/17.
//  Copyright © 2017 Dirk Hornung. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    @IBOutlet weak var MDisplay: UILabel!
    @IBOutlet weak var graphButton: UIButton!
    
    func updateUI() {
        let (result, isPending, description) = brain.evaluate()
        displayValue = result!
        descriptionDisplay.text = description
        
        // activate / desactivate graphButton
        if(!isPending) {
            graphButton.setTitle("📈", for: .normal)
        } else {
            graphButton.setTitle("🛑", for: .normal)
        }
    }
    
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
        if(userIsInTheMiddleOfTyping) {
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
        } else {
            brain.undo()
            updateUI()
        }
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        let variable = sender.currentTitle!
        brain.setOperand(variable)
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func evaluateVariable(_ sender: UIButton) {
        let variableValues: [String: Double] = ["M": displayValue]
        MDisplay.text = "M=\(displayValue)"
        let (result, _, description) = brain.evaluate(using: variableValues)
        userIsInTheMiddleOfTyping = false
        displayValue = result!
        descriptionDisplay.text = description
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.addOperation(mathematicalSymbol)
        }

        updateUI()
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        let (result, _, description) = brain.evaluate()
        userIsInTheMiddleOfTyping = false
        displayValue = result!
        descriptionDisplay.text = description
        MDisplay.text = " "
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let (_, pending, _) = self.brain.evaluate()
        return !pending
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            if let graphViewController = navigationController.visibleViewController as? GraphViewController {
                graphViewController.navigationItem.title = brain.description
                graphViewController.function = {
                    (x: CGFloat) -> CGFloat in
                        self.brain.variableValues["M"] = Double(x)
                    let (result, _, _) = self.brain.evaluate()
                    return CGFloat(result!)
                }
            }
        }
    }
}

