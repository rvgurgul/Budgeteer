//
//  BudgetItem.swift
//  BudgetApp
//
//  Created by Richie Gurgul on 3/31/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import Foundation

class BudgetItem
{
    var name = ""
    var percent: Float = 0.0
    var locked = false
    
    init(){}
    init(n: String){name = n}
    init(n: String, p: Int){name = n;percent = Float(p)}
    init(n: String, p: Float, l: Bool){name = n;percent = p;locked = l}
    
}