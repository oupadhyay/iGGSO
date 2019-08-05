//
//  SubmitCell.swift
//  HUSO
//
//  Created by Asher Noel on 8/3/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class SubmitCell: UITableViewCell
{

    @IBOutlet var photoContainer: UIView!
    @IBOutlet var itemButton: UIButton!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    
    func populateItem (entry: [String]) {
        itemTitle.text = entry[0]
        itemDescription.text = entry[1]
        
        photoContainer.layer.cornerRadius = 10
        photoContainer.layer.cornerRadius = 10
        photoContainer.layer.shadowOpacity = 0.35
        photoContainer.layer.shadowRadius = 7
        photoContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
        photoContainer.layer.shadowColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1).cgColor
        
        itemButton.setTitle("", for: .normal)
        itemButton.isEnabled = true
        
        
        
        if entry[0] == "Photos" {
            
            photoContainer.backgroundColor = UIColor.red
            
            backgroundImage.image = UIImage(named:"PhotosPhoto")
            
            
            
        } else if entry[0] == "Feedback" {
            
            photoContainer.backgroundColor = UIColor.green
    
             backgroundImage.image = UIImage(named:"FeedbackPhoto")
            
        } else if entry[0] == "Arbitration" {
            
            photoContainer.backgroundColor = UIColor.yellow
             backgroundImage.image = UIImage(named:"ArbitrationPhoto")
       
        }
        
    }
    
    
}

