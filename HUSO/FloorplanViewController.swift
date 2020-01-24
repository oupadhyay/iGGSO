//
//  FloorplanViewController.swift
//  HUSO
//
//  Created by Asher Noel on 8/5/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import SafariServices

class FloorplanViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var floorplanNames = ["Science Center Floor 1"]
    
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

extension FloorplanViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return floorplanNames.count
    }
    
    //Load the names into the cell and have the links clickable. 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorplanCell", for: indexPath) as! FloorplanCell
        
        let entry = floorplanNames[indexPath.row]
        
        cell.floorplanName.text = entry
        
        if entry == "Science Center Floor 1" {
            cell.floorplanButton.addTarget(self, action: #selector(self.linkScience1), for: .touchUpInside)
            
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        return cell
    }
    
    @objc func linkScience1 (sender: UIButton!) {
        guard let url = URL(string: "https://static1.squarespace.com/static/5b01cbef3917ee3d6b375fad/t/5dba1a859d4b0b572a06e2bd/1572477573238/SC+Floor+1.png") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
    
}
