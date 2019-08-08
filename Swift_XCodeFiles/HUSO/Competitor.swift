//
//  Competitor.swift
//  HUSO
//
//  Created by Asher Noel on 7/29/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import os.log

class Competitor: NSObject, NSCoding
{
    //MARK: Properties
    
    var division: String
    var teamName: String
    var teamNumber: String
    var homeroom: String
    var eventInformation: [[String]]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("competitor")
    
    //MARK: Types
    
    struct PropertyKey
    {
        static let division = "division"
        static let teamName = "teamName"
        static let teamNumber = "teamNumber"
        static let homeroom = "homeroom"
        static let eventInformation = "eventInformation"
    }
    
    //MARK: Initialization
    
    init?(division: String, teamName: String, teamNumber: String, homeroom: String, eventInformation: [[String]])
    {
        self.division = division
        self.teamName = teamName
        self.teamNumber = teamNumber
        self.homeroom = homeroom
        self.eventInformation = eventInformation
    }
    
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(division, forKey: PropertyKey.division)
        aCoder.encode(teamName, forKey: PropertyKey.teamName)
        aCoder.encode(teamNumber, forKey: PropertyKey.teamNumber)
        aCoder.encode(homeroom, forKey: PropertyKey.homeroom)
        aCoder.encode(eventInformation, forKey: PropertyKey.eventInformation)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let division = aDecoder.decodeObject(forKey: PropertyKey.division) as? String else {
            os_log("Unable to decode the division for a Competitor object", log: OSLog.default, type: .debug)
            return nil
        }
        
        let teamName = aDecoder.decodeObject(forKey: PropertyKey.teamName) as! String
        let teamNumber = aDecoder.decodeObject(forKey: PropertyKey.teamNumber) as! String
        let homeroom = aDecoder.decodeObject(forKey: PropertyKey.homeroom) as! String
        let eventInformation = aDecoder.decodeObject(forKey: PropertyKey.eventInformation) as! [[String]]
        
        self.init(division: division, teamName: teamName, teamNumber: teamNumber, homeroom: homeroom, eventInformation: eventInformation)
        
    }
    
    
    
}
