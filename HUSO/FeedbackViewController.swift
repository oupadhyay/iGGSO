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
    
    var feedbackInformation = [["Event Feedback Form ➤", "Non-App User link: \nharvardscioly.org/eventFeedback", "After every event, at most one teammate per event per team should use the event specific keyword provided by each event supervisor to recieve +1 bonus point added to your score or a comparable bonus in build events."],["Tournament Feedback Form ➤", "Non-App User link: \nharvardscioly.org/husoFeedback",  "After the award ceremony, competitors, coaches, and volunteers should help HUSO while also entering a lottery to recieve statistics about event raw scores."]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        
    
        
    }
  
}

extension FeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         print("tried to get number of rows")
        return feedbackInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackCell
  
        let entry = feedbackInformation[indexPath.row]
        
        cell.populateCell(entry: entry)
        
        if entry[0] == "Event Feedback Form" {
            cell.formLink.addTarget(self, action: #selector(self.linkEventForm), for: .touchUpInside)
            
        } else if entry[0] == "Tournament Feedback Form" {
            cell.formLink.addTarget(self, action: #selector(self.linkTournamentForm), for: .touchUpInside)
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        return cell
    }
    
    @objc func linkEventForm(sender: UIButton!) {
        guard let url = URL(string: "https://www.sciolyharvard.org/archive") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
    
    @objc func linkTournamentForm(sender: UIButton!) {
        guard let url = URL(string: "https://www.sciolyharvard.org/archive") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
}
