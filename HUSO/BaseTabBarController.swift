//
//  BaseTabBarController.swift
//  HUSO
//
//  Created by Asher Noel on 7/31/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//
import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 1
    
    //Set the default index to the page with the schedule.
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        
    }
    
}
