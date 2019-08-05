//
//  MoreCell.swift
//  HUSO
//
//  Created by Asher Noel on 8/2/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import UserNotifications

class MoreCell: UITableViewCell
{
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemButton: UIButton!
    
    var switchView = UISwitch()
    

    func populateItem(event: [String])
    {
        print("HELLOW!!!")
        itemTitle.text = event[0]
        if event[0] == "Notifications" {
            
            createButton()
            
            
            //add switch to button
            switchView = UISwitch(frame: .zero)
            switchView.setOn(self.pushEnabledAtOSLevel(), animated: true)
            
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            itemButton.addSubview(switchView)
            switchView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                       y: itemButton.frame.size.height / 2)
            switchView.onTintColor = UIColor(red: 255/255.0, green: 222/255.0, blue: 45/255.0, alpha: 1)
            
            itemButton.addTarget(self, action: #selector(self.toggleSwitch), for: .touchUpInside)
            
            
            
        } else if event[0] == "Results"
        {
            createButton()
            
            
            //Add link image to button
            let imageView = UIImageView(image: UIImage(named: "Link")!)
            imageView.frame = CGRect(x: 0, y: 0, width: 50, height:50)
            itemButton.addSubview(imageView)
            imageView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                       y: itemButton.frame.size.height / 2)

            
        } else if event [0] == "Website" {
            
            createButton()
            
            
            //Add link image to button
            let imageView = UIImageView(image: UIImage(named: "HUSOLogo3")!)
            imageView.frame = CGRect(x: 0, y: -10, width: 55, height:55)
            itemButton.addSubview(imageView)
            imageView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                         y: itemButton.frame.size.height / 2)
            imageView.center.y = imageView.center.y+2
        } else if event[0] == "Contact" {
            
            createButton()
            let imageView = UIImageView(image: UIImage(named: "Contact")!)
            imageView.frame = CGRect(x: 0, y: 0, width: 45, height:45)
            itemButton.addSubview(imageView)
            imageView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                       y: itemButton.frame.size.height / 2)
            imageView.center.x = imageView.center.x-2
        } else if event[0] == "Emergency" {
            createButton()
            let imageView = UIImageView(image: UIImage(named: "Police")!)
            imageView.frame = CGRect(x: 0, y: 0, width: 45, height:45)
            itemButton.addSubview(imageView)
            imageView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                       y: itemButton.frame.size.height / 2)
            
        } else if event[0] == "Report" {
            createButton()
            let imageView = UIImageView(image: UIImage(named: "Bug")!)
            imageView.frame = CGRect(x: 0, y: 0, width: 52, height:52)
            itemButton.addSubview(imageView)
            imageView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                       y: itemButton.frame.size.height / 2)
        } else if event[0] == "Tests" {
            
            createButton()
            let imageView = UIImageView(image: UIImage(named: "Test")!)
            imageView.frame = CGRect(x: 0, y: 0, width: 52, height:52)
            itemButton.addSubview(imageView)
            imageView.center = CGPoint(x: itemButton.frame.size.width  / 2,
                                       y: itemButton.frame.size.height / 2)
        }
        
        
        itemDescription.text = event[1]
    }
    

    
    @objc func switchChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    if !granted {
                        self.openSettings()
                    }
                }
            
            print("turn on notificaitons")
            //add user to list
            
        } else {
            //Turn off post notifications
            // remove user from list
            if pushEnabledAtOSLevel() {
                self.openSettings()
            }
            
            print("turn off notificaitons")
            
        }
    }
    
    @objc func toggleSwitch(_ sender: UIButton) {
        if (switchView.isOn) {
            switchView.setOn(false, animated: true)
            switchChanged(switchView)
        } else {
            switchView.setOn(true, animated: true)
            switchChanged(switchView)
        }
    }
    
    func createButton() {
        itemButton.layer.cornerRadius = 40
        self.accessoryView = itemButton
        
        itemButton.backgroundColor = UIColor(red: 237/255.0, green: 27/255.0, blue: 52/255.0, alpha: 1)
        itemButton.layer.shadowOpacity = 1
        itemButton.layer.shadowRadius = 3
        itemButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        itemButton.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
        itemButton.isEnabled = true

    }
    
    func pushEnabledAtOSLevel() -> Bool {
        guard let currentSettings = UIApplication.shared.currentUserNotificationSettings?.types else { return false }
        return currentSettings.rawValue != 0
    }
    
    func openSettings() {
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings as URL)
        }
    }
    
}
