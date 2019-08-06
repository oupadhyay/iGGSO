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
    
    var floorplanNames = ["Science Floor 1 (coming soon)", "Science Floor 2 (coming soon)", "Harvard Floor 1 (coming soon)"]
    
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
        
        if entry == "Science Floor 1 (coming soon)" {
            cell.floorplanButton.addTarget(self, action: #selector(self.linkScience1), for: .touchUpInside)
            
        } else if entry == "Science Floor 2 (coming soon)" {
            cell.floorplanButton.addTarget(self, action: #selector(self.linkScience2), for: .touchUpInside)
        } else if entry == "Harvard Floor 1 (coming soon)" {
            cell.floorplanButton.addTarget(self, action: #selector(self.linkHarvard1), for: .touchUpInside)
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        return cell
    }
    
    @objc func linkScience1 (sender: UIButton!) {
        guard let url = URL(string: "https://www.sciolyharvard.org") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
    
    @objc func linkScience2 (sender: UIButton!) {
        guard let url = URL(string: "https://www.sciolyharvard.org") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
    
    @objc func linkHarvard1 (sender: UIButton!) {
        guard let url = URL(string: "https://www.sciolyharvard.org") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
}
