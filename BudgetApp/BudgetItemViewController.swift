//
//  BudgetItemViewController.swift
//  BudgetApp
//
//  Created by Richie Gurgul on 4/18/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class BudgetItemViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var expenseNameField: UITextField!
    @IBOutlet weak var allocatedIncomeField: UITextField!
    @IBOutlet weak var allocatedIncomeSlider: UISlider!
    @IBOutlet weak var chosenPercentField: UITextField!
    @IBOutlet weak var lockValuesButton: UIBarButtonItem!
    
    var income: Float = 0.0
    var item = BudgetItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if income == 0
        {
            allocatedIncomeField.userInteractionEnabled = false
            allocatedIncomeSlider.userInteractionEnabled = false
            chosenPercentField.userInteractionEnabled = false
        }
        
        navigationController?.navigationBar.tintColor = UIColor(red: 85/255, green: 170/255, blue: 255/255, alpha: 1)
        
        expenseNameField.text = item.name
        allocatedIncomeField.text = "$" + String(format: "%.2f", income * item.percent / 100)
        allocatedIncomeSlider.value = item.percent / 100
        chosenPercentField.text = String(format: "%.2f", item.percent) + "%"
        lockImages()
    }
    
    @IBAction func lockItem(sender: AnyObject)
    {
        item.locked = !item.locked
        lockImages()
    }
    
    func lockImages()
    {
        if item.locked {lockValuesButton.image = UIImage(named: "locked")}
        else {lockValuesButton.image = UIImage(named: "unlocked")}
    }
    
    @IBAction func onSliderValueChange(sender: AnyObject)
    {
        let roundedValue = allocatedIncomeSlider.value - allocatedIncomeSlider.value % 0.0025
        allocatedIncomeField.text = "$" + String(format: "%.2f", Float(roundedValue) * income)
        allocatedIncomeSlider.value = roundedValue
        chosenPercentField.text = String(format: "%.2f", roundedValue * 100) + "%"
        item.percent = roundedValue * 100
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        //expenseNameField
        if textField.tag == 1 {item.name = textField.text!}
        //allocatedIncomeField
        else if textField.tag == 2
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            item.percent = (textField.text! as NSString).floatValue / income * 100
            
            checkForNANs()
        }
        //chosenPercentField
        else if textField.tag == 3
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            item.percent = (textField.text! as NSString).floatValue
            
            checkForNANs()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //expenseNameField
        if textField.tag == 1 {item.name = textField.text!}
        //allocatedIncomeField
        else if textField.tag == 2
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let allocatedIncome = (textField.text! as NSString).floatValue
            let chosenPercent = allocatedIncome / income * 100
            
            allocatedIncomeField.text = "$" + String(format: "%.2f", allocatedIncome)
            allocatedIncomeSlider.value = chosenPercent / 100
            chosenPercentField.text = String(format: "%.2f", chosenPercent) + "%"
            
            item.percent = chosenPercent
            
            checkForNANs()
        }
        //chosenPercentField
        else if textField.tag == 3
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let chosenPercent = (textField.text! as NSString).floatValue
            allocatedIncomeField.text = "$" + String(format: "%.2f", income * chosenPercent / 100)
            allocatedIncomeSlider.value = chosenPercent / 100
            chosenPercentField.text = String(format: "%.2f", chosenPercent) + "%"
            
            item.percent = chosenPercent
            
            checkForNANs()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func checkForNANs()
    {
        let newAllocatedIncomeFieldText = allocatedIncomeField.text!.stringByReplacingOccurrencesOfString("nan", withString: "0", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let newChosenPercentFieldText = chosenPercentField.text!.stringByReplacingOccurrencesOfString("nan", withString: "0", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if allocatedIncomeField.text != newAllocatedIncomeFieldText || chosenPercentField.text != newChosenPercentFieldText
        {
            allocatedIncomeField.text = newAllocatedIncomeFieldText
            chosenPercentField.text = newChosenPercentFieldText
            allocatedIncomeSlider.value = 0
        }
    }
}
