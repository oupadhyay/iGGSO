//
//  ScheduleViewController.swift
//  HUSO
//
//  Created by Asher Noel on 7/31/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import MapKit

class ScheduleViewController: UIViewController
{
    
    @IBOutlet var teamNameLabel: UILabel!
    @IBOutlet var teamNumberLabel: UILabel!
    @IBOutlet var homeroomLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var competitor: Competitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //If a schedule cell is clicked, the corresponding location will open in Apple Maps.
    func openMapForPlace(location: String, latitude: String, longitude: String) {
        
        let latitude1: CLLocationDegrees = Double(latitude)!
        let longitude1: CLLocationDegrees = Double(longitude)!
        
        let regionDistance:CLLocationDistance = 600
        let coordinates = CLLocationCoordinate2DMake(latitude1, longitude1)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(location)"
        mapItem.openInMaps(launchOptions: options)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = competitor?.eventInformation[indexPath.row]
        openMapForPlace(location: event![1], latitude: event![6], longitude: event![7])
    }
}
