//
//  ViewController.swift
//  Calculator
//
//  Created by John Lima on 09/10/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get {return Double(self.display.text!)!}
        set {self.display.text = String(newValue)}
    }
    
    // MARK: - Actions
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if self.userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = self.display.text!
            self.display.text = textCurrentlyInDisplay + digit
        }else {
            self.display.text = digit
        }
        
        self.userIsInTheMiddleOfTyping = true
    }

    @IBAction private func performOperation(sender: UIButton) {
        
        if self.userIsInTheMiddleOfTyping {
            self.brain.set(operand: self.displayValue)
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            self.brain.performOperation(symbol: mathematicalSymbol)
        }
        
        self.displayValue = self.brain.result
    }
    
}

