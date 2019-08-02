//
//  ScheduleViewController.swift
//  HUSO
//
//  Created by Asher Noel on 7/31/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController
{
    
    @IBOutlet var teamNameLabel: UILabel!
    @IBOutlet var teamNumberLabel: UILabel!
    @IBOutlet var homeroomLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var competitor: Competitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        competitor = loadCompetitor()
        
        teamNameLabel.text = competitor?.teamName
        teamNumberLabel.text = competitor?.teamNumber
        homeroomLabel.text = competitor?.homeroom
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func loadCompetitor() -> Competitor?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Competitor.ArchiveURL.path) as? Competitor
    }
    
    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (competitor?.eventInformation.count)!
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellIdentifier = "ScheduleCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ScheduleCell
        
        
        let event = competitor?.eventInformation[indexPath.row]
        
        cell.createCell(event: event!)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
       
        return cell
    }
    
    
    
}
