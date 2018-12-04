//
//  TodayViewController.swift
//  CalculatorWidget
//
//  Created by Moin Uddin on 12/3/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit
import NotificationCenter
import RPN
class TodayViewController: UIViewController, NCWidgetProviding, UITextFieldDelegate {
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = CGSize(width: 0, height: 0)
            //inputTextField.isHidden = true
            calculatorStackView.isHidden = true
        case .expanded:
            preferredContentSize = CGSize(width: maxSize.width, height: 300)
                //inputTextField.isHidden = false
                calculatorStackView.isHidden = false

        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var calculatorStackView: UIStackView!
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        try? digitAccumulator.add(digit: .number(sender.tag))
    }
    
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        try? digitAccumulator.add(digit: .decimalPoint)
    }
    
    @IBAction func returnButtonTapped(_ sender: UIButton) {
        if let value = digitAccumulator.value() {
            calculator.push(number: value)
        }
        digitAccumulator.clear()
    }
    
    @IBAction func divideButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .divide)
    }
    
    @IBAction func multiplyButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .multiply)
    }
    
    @IBAction func subtractButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .subtract)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .add)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        calculator.clear()
        digitAccumulator.clear()
        return true
    }
    
    @IBAction func copyTextFIeld(_ sender: Any) {
        
        UIPasteboard.general.string = textField.text
    }
    
    
    // MARK: - Properties
    
    @IBOutlet var textField: UITextField!
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.maximumIntegerDigits = 20
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 20
        return formatter
    }()
    
    private var calculator = Calculator() {
        didSet {
            if let value = calculator.topValue {
                textField.text = numberFormatter.string(from: value as NSNumber)
            } else {
                textField.text = ""
            }
        }
    }
    
    private var digitAccumulator = DigitAccumulator() {
        didSet {
            if let value = digitAccumulator.value() {
                textField.text = numberFormatter.string(from: value as NSNumber)
            } else {
                textField.text = ""
            }
        }
    }
}
