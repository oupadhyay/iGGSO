//
//  EventsViewController.swift
//  HUSO
//
//  Created by Asher Noel on 7/30/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import os.log

class EventsViewController: UIViewController
{
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    var events = [String]()
    var chosenEvents = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true

        saveButton.isEnabled = false
        saveButton.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let selectedRows = tableView.indexPathsForSelectedRows
        
        for item in selectedRows!
        {
            chosenEvents.append(events[item[1]])
  
        }
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellIdentifier = "EventCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventCell 

        
        let event = events[indexPath.row]

        cell.setEvent(event: event)
        
        cell.eventLabel?.text = event
        
        //Multiple Selection

        //let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        cell.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        //cell.accessoryType = .checkmark
        
        if !(tableView.indexPathsForSelectedRows == nil) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        //cell.accessoryType = .none
        
        if !(tableView.indexPathsForSelectedRows == nil) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    

}
