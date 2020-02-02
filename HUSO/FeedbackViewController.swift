//
//  FeedbackViewController.swift
//  HUSO
//
//  Created by Asher Noel on 8/3/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import SafariServices

class FeedbackViewController: UIViewController, SFSafariViewControllerDelegate
{
    
    @IBOutlet var tableView: UITableView!
    
    var feedbackInformation = [["Event Feedback Form ➤", "Non-App User link: \nhttps://forms.gle/McqedUqR2MJBnjoG7", "After every event, both teammates should complete this form. \n \nAt most one teammate per event per team can use the event specific keyword provided by each event supervisor to recieve a tie-breaking bonus point added or subtracted to their score in some events."],["Tournament Feedback Form ➤", "Non-App User link: \nhttps://forms.gle/6jmzn911dg9JRsUW8",  "After the award ceremony, competitors, coaches, and volunteers should complete this form to help HUSO and enter a lottery to recieve statistics about event raw scores."]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Show the navigation bar.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
  
}

extension FeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feedbackInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackCell
        let entry = feedbackInformation[indexPath.row]
        cell.populateCell(entry: entry)
        
        if entry[0] == "Event Feedback Form ➤" {
            cell.formLink.addTarget(self, action: #selector(self.linkEventForm), for: .touchUpInside)
            
        } else if entry[0] == "Tournament Feedback Form ➤" {
            cell.formLink.addTarget(self, action: #selector(self.linkTournamentForm), for: .touchUpInside)
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    @objc func linkEventForm(sender: UIButton!) {
        guard let url = URL(string: "https://forms.gle/McqedUqR2MJBnjoG7") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
    
    @objc func linkTournamentForm(sender: UIButton!) {
        guard let url = URL(string: "https://forms.gle/6jmzn911dg9JRsUW8") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }
}
