//
//  BudgetSection.swift
//  BudgetApp
//
//  Created by Richie Gurgul on 4/4/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import Foundation

class BudgetSection
{
    var name = ""
    var items = [BudgetItem]()
    
    init(n: String){name = n}
    
    func addItem(n: String, p: Int)
    {
        items.append(BudgetItem(n: n, p: p))
    }
    
    func addItem(n: String, p: Float, l: Bool)
    {
        items.append(BudgetItem(n: n, p: p, l: l))
    }
}