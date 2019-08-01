//
//  SetupTextFields.swift
//  HUSO
//
//  Created by Asher Noel on 7/29/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class SetupTextFields: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderStyle = .none
        self.backgroundColor = UIColor.white // Use anycolor that give you a 2d look.
        self.tintColor = UIColor.clear
        
        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        
        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        
        if (self.isUserInteractionEnabled == false) {
            self.layer.shadowColor = UIColor(red: 236.0/255, green: 143.0/255, blue: 153.0/255, alpha: 1).cgColor
            self.attributedPlaceholder = NSAttributedString(string: self.attributedPlaceholder!.string,attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 236.0/255, green: 143.0/255, blue: 153.0/255, alpha: 1)])
        }

        else {

            //RED
            self.layer.shadowColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1).cgColor
           self.attributedPlaceholder = NSAttributedString(string: self.attributedPlaceholder!.string, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)])


            //GREEN
//            self.layer.shadowColor = UIColor(red: 77.0/255, green: 184.0/255, blue: 72.0/255, alpha: 1).cgColor
//             self.attributedPlaceholder = NSAttributedString(string: self.attributedPlaceholder!.string, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 77.0/255, green: 184.0/255, blue: 72.0/255, alpha: 1)])

        }
    }
}

    
    


