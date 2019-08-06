//
//  FeedbackCell.swift
//  HUSO
//
//  Created by Asher Noel on 8/4/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class FeedbackCell: UITableViewCell
{
    
    @IBOutlet var formLink: UIButton!
    @IBOutlet var formDescription: UILabel!
    @IBOutlet var formDirections: UILabel!
    
    func populateCell(entry: [String])
    {
        formLink.setTitle(entry[0], for: .normal)
        formDescription.text = entry[1]
        formDirections.text = entry[2]
        formLink.isEnabled = true
    }
}
