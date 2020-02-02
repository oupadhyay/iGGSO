//
//  SubmitViewController.swift
//  HUSO
//
//  Created by Asher Noel on 7/31/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import SafariServices

class SubmitViewController: UIViewController, SFSafariViewControllerDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var submitInformation = [["Photos", "Be featured in the Awards Ceremony slideshow."],["Feedback", "Complete a form after every event. Recieve bonus points."], ["Arbitration", "Defend against unfair or improper treatment."]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    //Remove the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension SubmitViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return submitInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitCell", for: indexPath) as! SubmitCell
   
        let entry = submitInformation[indexPath.row]
        cell.populateItem(entry: entry)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if entry[0] == "Feedback" {
            cell.itemButton.addTarget(self, action: #selector(self.feedbackSegue), for: .touchUpInside)
            
        } else if entry[0] == "Photos" {
            cell.itemButton.addTarget(self, action: #selector(self.photosSegue), for: .touchUpInside)
        } else if entry[0] == "Arbitration" {
            cell.itemButton.addTarget(self, action: #selector(self.linkWebsite(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func feedbackSegue () {
        performSegue(withIdentifier: "feedbackSegue", sender: self)
    }
    
    @objc func photosSegue () {
        performSegue(withIdentifier: "photosSegue", sender: self)
    }
    
    @objc func linkWebsite(sender: UIButton!) {
            
        guard let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSedhAWEo1mQ9L20ZA9gGhxaVSBIc2eF4U4DlX-je9o30NoCxA/viewform") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
            
    }
}


