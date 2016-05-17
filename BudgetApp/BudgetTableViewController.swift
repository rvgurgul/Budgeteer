//
//  BudgetTableViewController.swift
//  BudgetApp
//
//  Created by Richie Gurgul on 4/4/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class BudgetTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    @IBOutlet weak var monthlyIncomeField: UITextField!
    
    var sections = [BudgetSection]()
    var totalPercent: Float = 0.0
    var income: Float = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        load()
        
        navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.navigationBar.tintColor = UIColor(red: 85/255, green: 170/255, blue: 255/255, alpha: 1)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        tableView.reloadData()
        save()
        checkPercents()
    }
    
    func save()
    {
        let data = NSUserDefaults.standardUserDefaults()
        
        var sectionNames = [String]()
        var itemNames = [[String]]()
        var itemPercents = [[Float]]()
        var itemLocks = [[Bool]]()
        
        for i in 0..<sections.count
        {
            let section = sections[i]
            sectionNames.append(section.name)
            itemNames.append([String]())
            itemPercents.append([Float]())
            itemLocks.append([Bool]())
            
            for j in 0..<sections[i].items.count
            {
                let item = section.items[j]
                itemNames[i].append(item.name)
                itemPercents[i].append(item.percent)
                itemLocks[i].append(item.locked)
            }
        }
        data.setValue(sectionNames, forKey: "sectionNames")
        data.setValue(itemNames, forKey: "itemNames")
        data.setValue(itemPercents, forKey: "itemPercents")
        data.setValue(itemLocks, forKey: "itemLocks")
        data.setValue(income, forKey: "income")
        data.synchronize()
    }
    
    func load()
    {
        let data = NSUserDefaults.standardUserDefaults()
        
        var sectionNames: [String]! = nil
        var itemNames: [[String]]! = nil
        var itemPercents: [[Float]]! = nil
        var itemLocks: [[Bool]]! = nil
        
        if let _ = data.objectForKey("sectionNames") as? [String]
        {
            sectionNames = data.objectForKey("sectionNames") as! [String]
        }
        else {addDefaultSections();return}
        
        if let _ = data.objectForKey("itemNames") as? [[String]]
        {
            itemNames = data.objectForKey("itemNames") as! [[String]]
        }
        else {addDefaultSections();return}
        
        if let _ = data.objectForKey("itemPercents") as? [[Float]]
        {
            itemPercents = data.objectForKey("itemPercents") as! [[Float]]
        }
        else {addDefaultSections();return}
        
        if let _ = data.objectForKey("itemLocks") as? [[Bool]]
        {
            itemLocks = data.objectForKey("itemLocks") as! [[Bool]]
        }
        else {addDefaultSections();return}
        
        if let _ = data.objectForKey("income") as? Float
        {
            income = data.objectForKey("income") as! Float
            monthlyIncomeField.text = "$" + String(format: "%.2f", income)
        }
        else {addDefaultSections();return}
        
        for i in 0..<sectionNames.count
        {
            sections.append(BudgetSection(n: sectionNames[i]))
            for j in 0..<itemNames[i].count
            {
                sections[i].addItem(itemNames[i][j], p: itemPercents[i][j], l: itemLocks[i][j])
            }
        }
    }
    
    func addDefaultSections()
    {
        sections.append(BudgetSection(n: "Taxes"))
            sections[0].addItem("Income", p: 0)
            sections[0].addItem("Property", p: 0)
        sections.append(BudgetSection(n: "Housing"))
            sections[1].addItem("Repairs", p: 0)
            sections[1].addItem("Rent", p: 0)
        sections.append(BudgetSection(n: "Savings"))
            sections[2].addItem("Emergency Fund", p: 0)
            sections[2].addItem("Retirement", p: 0)
        sections.append(BudgetSection(n: "Transportation"))
            sections[3].addItem("Gas", p: 0)
            sections[3].addItem("Repairs", p: 0)
            sections[3].addItem("Insurance", p: 0)
        sections.append(BudgetSection(n: "Personal"))
            sections[4].addItem("Food", p: 0)
            sections[4].addItem("Clothes", p: 0)
            sections[4].addItem("Fun", p: 0)
        sections.append(BudgetSection(n: "Utilities"))
            sections[5].addItem("Water", p: 0)
            sections[5].addItem("Heating", p: 0)
            sections[5].addItem("Electricity", p: 0)
        sections.append(BudgetSection(n: "Charity"))
            sections[6].addItem("Donations", p: 0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = UILabel()
        header.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 191/255, alpha: 1.0)
        header.text = sections[section].name
        header.textAlignment = .Center
        return header
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section].name
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].items.count
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let item = sections[sourceIndexPath.section].items.removeAtIndex(sourceIndexPath.row)
        sections[destinationIndexPath.section].items.insert(item, atIndex: destinationIndexPath.row)
        removeUnusedSections()
        tableView.reloadData()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.text = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        income = (textField.text! as NSString).floatValue
        
        if income < 0 {return false}
        
        textField.text = "$" + String(format: "%.2f", income)
        textField.resignFirstResponder()
        
        tableView.reloadData()
        save()
        return true
    }
    
    @IBAction func addBudgetItem(sender: UIBarButtonItem)
    {
        let addAlert = UIAlertController(title: "Add a new expense to your budget.", message: nil, preferredStyle: .Alert)
        addAlert.addTextFieldWithConfigurationHandler
        {   (itemName) -> Void in
            itemName.placeholder = "Budget Item Name"
            itemName.autocapitalizationType = .Words
        }
        addAlert.addTextFieldWithConfigurationHandler
        {   (sectionName) -> Void in
            sectionName.placeholder = "Budget Section Name"
            sectionName.autocapitalizationType = .Words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let addAction = UIAlertAction(title: "Confirm", style: .Default)
        {   (action) -> Void in
            var added = false
            var itemName = "New Item"
            var sectionName = "Other"
            
            if addAlert.textFields![0].text != ""
            {itemName = addAlert.textFields![0].text!.capitalizedString}
            if addAlert.textFields![1].text != ""
            {sectionName = addAlert.textFields![1].text!.capitalizedString}
            
            for section in self.sections
            {
                if section.name.lowercaseString == sectionName.lowercaseString
                {
                    section.addItem(itemName, p: 0)
                    added = true
                    break
                }
            }
            
            if !added
            {
                let index = self.sections.count
                self.sections.append(BudgetSection(n: sectionName))
                self.sections[index].addItem(itemName, p: 0)
            }
            
            self.tableView.reloadData()
        }
        
        addAlert.addAction(cancelAction)
        addAlert.addAction(addAction)
        
        presentViewController(addAlert, animated: true, completion: nil)
    }
    
    @IBAction func moreToolsButtonTap(sender: UIBarButtonItem)
    {
        let listAlert = UIAlertController(title: "Choose an option.", message: nil, preferredStyle: .ActionSheet)
        
        let interestCalculatorSegue = UIAlertAction(title: "Interest Calculator", style: .Default)
        {   (action) -> Void in
            self.performSegueWithIdentifier("toInterestCalculator", sender: self)
        }
        
        let resetAction = UIAlertAction(title: "Reset Budget", style: .Destructive)
        {   (action) -> Void in
            let confirmAlert = UIAlertController(title: "Are you sure?", message: "This will reset your entire budget.", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Yes", style: .Default, handler:
            {   (action) -> Void in
                for section in self.sections
                {
                    for item in section.items
                    {
                        item.percent = 0
                        item.locked = false
                    }
                }
                self.tableView.reloadData()
                self.save()
            })
            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            
            confirmAlert.addAction(confirmAction)
            confirmAlert.addAction(cancelAction)
            
            self.presentViewController(confirmAlert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        listAlert.addAction(interestCalculatorSegue)
        listAlert.addAction(resetAction)
        listAlert.addAction(cancelAction)
        
        presentViewController(listAlert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            sections[indexPath.section].items.removeAtIndex(indexPath.row)
            removeUnusedSections()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let itemCell = tableView.dequeueReusableCellWithIdentifier("budgetItem", forIndexPath: indexPath)
        itemCell.textLabel?.text = sections[indexPath.section].items[indexPath.row].name
        
        let itemPercent = sections[indexPath.section].items[indexPath.row].percent
        
        if (itemPercent == 0){itemCell.detailTextLabel?.text = "$0.00 (0.00%)"}
        else {itemCell.detailTextLabel?.text = "$ \(String(format: "%.2f" , income * itemPercent / 100)) (\(String(format: "%.2f", itemPercent)) %)"}
        
        return itemCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toDetailedView"
        {
            let nextVC = segue.destinationViewController as! BudgetItemViewController
            nextVC.income = Float(income)
            let IP = tableView.indexPathForSelectedRow!
            nextVC.item = sections[IP.section].items[IP.row]
        }
    }
    
    func removeUnusedSections()
    {
        for i in 0..<sections.count
        {
            if sections[i].items.count == 0 {sections.removeAtIndex(i)}
        }
        tableView.reloadData()
        save()
    }
    
    func checkPercents()
    {
        totalPercent = 0.0
        for section in sections
        {
            for item in section.items
            {
                totalPercent += item.percent
            }
        }
        
        if(totalPercent > 100.0)
        {
            let overageAlert = UIAlertController(title: "Over 100%!", message: "You have used \(totalPercent)% of your monthly income. Try to balance your budget!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            let balanceAction = UIAlertAction(title: "Balance", style: .Default, handler:
            {   (action) -> Void in
                self.autoBalance()
            })
            
            overageAlert.addAction(cancelAction)
            overageAlert.addAction(balanceAction)
            presentViewController(overageAlert, animated: true, completion: nil)
        }
    }
    
    func autoBalance()
    {
        var unlockedPercentSum: Float = 0.0
        var lockedPercentSum: Float = 0.0
        
        for section in sections
        {
            for item in section.items
            {
                if !item.locked {unlockedPercentSum += item.percent}
                else {lockedPercentSum += item.percent}
            }
        }
        
        if lockedPercentSum > 100.0
        {
            let errorAlert = UIAlertController(title: "Locked Percents Over 100%", message: "Locked item percentages are \(lockedPercentSum)%! Please unlock items and try again.", preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            errorAlert.addAction(dismissAction)
            
            presentViewController(errorAlert, animated: true, completion: nil)
        }
        else
        {
            for section in sections
            {
                for item in section.items
                {
                    if !item.locked {item.percent -= (item.percent / unlockedPercentSum) * (totalPercent - 100)}
                }
            }
        }
        
        tableView.reloadData()
        save()
    }
}
