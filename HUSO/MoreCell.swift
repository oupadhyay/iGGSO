//
//  MoreCell.swift
//  HUSO
//
//  Created by Asher Noel on 8/2/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell
{
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var updatesBackground: UIView!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var switchOutlet: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            //push notifications onn
            //add to list
        } else {
            //push notifications off
            //remove from list
        }
    }
    
    
    
    func setItem(event: String)
    {
    }
}
