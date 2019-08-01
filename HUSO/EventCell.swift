//
//  EventCell.swift
//  HUSO
//
//  Created by Asher Noel on 7/30/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    
    @IBOutlet var eventLabel: UILabel!
    
    
    
    func setEvent(event: String) {
        
        eventLabel.text = event
        

    }
}
