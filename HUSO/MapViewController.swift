//
//  MapViewController.swift
//  HUSO
//
//  Created by Asher Noel on 7/31/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var itemButton: UIButton!
    let mapInformation = ["Floorplans","Campus Maps"]
    
    var competitor: Competitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        itemButton.layer.shadowOpacity = 1
        itemButton.layer.shadowRadius = 3
        itemButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        itemButton.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
        
        competitor = loadCompetitor()
        
        var latitudes = [Double]()
        var longitudes = [Double]()
    
        for event in (competitor?.eventInformation)!.reversed() {
            let annotation = MKPointAnnotation()
            
            let latitude1: CLLocationDegrees = Double(event[6])!
            let longitude1: CLLocationDegrees = Double(event[7])!
            
            if !latitudes.contains(Double(event[6])!) {
                latitudes.append(Double(event[6])!)
            }
            if !longitudes.contains(Double(event[7])!) {
                longitudes.append(Double(event[7])!)
            }
            
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude1, longitude: longitude1)
            annotation.title = "\(event[1])"
            annotation.subtitle = "The room name of one of your events in this building"
            mapView.addAnnotation(annotation)
        }
        
        let latitude1: CLLocationDegrees = latitudes.average
        let longitude1: CLLocationDegrees = longitudes.average
        let coordinates = CLLocationCoordinate2DMake(latitude1, longitude1)
        let initialLocation = CLLocation(latitude: latitude1, longitude: longitude1)
        let regionRadius: CLLocationDistance = 400
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: coordinates,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
    }
    
    //Remove the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //Load competitor data from the device.
    private func loadCompetitor() -> Competitor?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Competitor.ArchiveURL.path) as? Competitor
    }
}

//Average extensions for different types of numbers. 
extension Collection where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
