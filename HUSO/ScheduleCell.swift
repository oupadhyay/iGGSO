//
//  ScheduleCell.swift
//  HUSO
//
//  Created by Asher Noel on 8/1/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell
{
    @IBOutlet var timeHHMM: UILabel!
    @IBOutlet var timeAMPM: UILabel!
    @IBOutlet var itemTypeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var trialLabel: UILabel!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var timeCircle: UIImageView!
    
    
    func createCell(event: [String])
    {
        eventNameLabel.text = event[0]
        locationLabel.text = event[1]
        if event[2].count <= 7 {
            timeHHMM.text = String(event[2].prefix(4))
        } else {
            timeHHMM.text = String(event[2].prefix(5))
        }
        
        timeAMPM.text = String(event[2].suffix(2))
        
        if event[4] == "Yes" {
            trialLabel.text = "TRIAL"
        } else {
            trialLabel.text = ""
        }
        
        itemTypeLabel.text = event[5]
        
        if ((event[5] == "IMPOUND") || (event[5] == "HUSO")) {
            timeCircle.image = UIImage(named: "impoundBackground")
        }
        
        if event[5] == "EVENT" {
            timeCircle.image = UIImage(named: "scheduleBackground")
        }
        
    }
}
