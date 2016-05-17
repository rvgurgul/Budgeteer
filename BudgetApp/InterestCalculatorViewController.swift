//
//  InterestCalculatorViewController.swift
//  BudgetApp
//
//  Created by Richie Gurgul on 4/28/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class InterestCalculatorViewController: UIViewController, UITextFieldDelegate
{
    var A: Float = 0.0
    @IBOutlet weak var finalAmountField: UITextField!
    
    var P: Float = 0.0
    @IBOutlet weak var principalField: UITextField!
    
    var r: Float = 0.0
    @IBOutlet weak var interestRateField: UITextField!
    @IBOutlet weak var interestRateSlider: UISlider!
    
    var n = 0
    @IBOutlet weak var timesCompoundedField: UITextField!
    @IBOutlet weak var timesCompoundedStepper: UIStepper!
    
    var t = 0
    @IBOutlet weak var yearsCompoundedField: UITextField!
    @IBOutlet weak var yearsCompoundedStepper: UIStepper!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 85/255, green: 170/255, blue: 255/255, alpha: 1)
    }
    
    /*TEXT FIELD DELEGATE FUNCTIONS*/
    func textFieldShouldReturn(textField: UITextField) -> Bool {calcAction(textField);return true}
    func textFieldDidEndEditing(textField: UITextField) {calcAction(textField)}
    /*TEXT FIELD DELEGATE FUNCTIONS*/
    
    @IBAction func clearEntriesButtonTap(sender: AnyObject)
    {
        P = 0.0
        principalField.text = ""
        
        r = 0.0
        interestRateField.text = ""
        interestRateSlider.value = 0.0
        
        n = 0
        timesCompoundedField.text = ""
        timesCompoundedStepper.value = 0
        
        t = 0
        yearsCompoundedField.text = ""
        yearsCompoundedStepper.value = 0
        
        A = 0.0
        finalAmountField.text = ""
    }
    
    
    @IBAction func interestRateChanged(sender: UISlider)
    {
        r = sender.value
        interestRateField.text = String(format: "%.1f", r) + "%"
        calculate()
    }
    
    @IBAction func timesCompoundedChanged(sender: UIStepper)
    {
        n = Int(sender.value)
        if n < 1 {n = 1; sender.value = 1}
        if n > 365 {n = 365; sender.value = 365}
        timesCompoundedField.text = "\(n)"
        calculate()
    }
    
    @IBAction func yearsCompoundedChanged(sender: UIStepper)
    {
        t = Int(sender.value)
        if t < 1 {t = 1; sender.value = 1}
        if t > 365 {t = 365; sender.value = 365}
        yearsCompoundedField.text = "\(t)"
        calculate()
    }
    
    func calcAction(textField: UITextField)
    {
        if textField.tag == 1 //principalField
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            P = (textField.text! as NSString).floatValue
            textField.text = "$" + String(format: "%.2f", P)
        }
        else if textField.tag == 2 //interestRateField
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            r = (textField.text! as NSString).floatValue
            textField.text = String(format: "%.2f", r) + "%"
            interestRateSlider.value = r
        }
        else if textField.tag == 3 //timeCompoundedField
        {
            n = (textField.text! as NSString).integerValue
            textField.text = "\(n)"
            timesCompoundedStepper.value = Double(n)
        }
        else if textField.tag == 4 //yearsCompoundedField
        {
            t = (textField.text! as NSString).integerValue
            textField.text = "\(t)"
            yearsCompoundedStepper.value = Double(t)
        }
        textField.resignFirstResponder()
        calculate()
    }
    
    func calculate()
    {
        if n == 0 {return}
        
        let value = 1 + ((r / 100) / Float(n))
        let power = Float(n * t)
        
        A = P * pow(value, power)
        finalAmountField.text = "$" + String(format: "%.2f", A)
    }
}
