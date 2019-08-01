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
    var teamNumber: Int
    var events: [String] = []
    
    //var tournamentInformation: TournamentInformation
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("competitor")
    
    //MARK: Types
    
    struct PropertyKey
    {
        static let division = "division"
        static let teamNumber = "teamNumber"
        static let events = "events"
        //static let tournamentInformation = "tournamentInformation"
    }
    
    //MARK: Initialization
    
    init?(division: String, teamNumber: Int, events: [String])
    {
        self.division = division
        self.teamNumber = teamNumber
        self.events = events
        //self.tournamentInformation = tournamentInformation
    }
    
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(division, forKey: PropertyKey.division)
        aCoder.encode(teamNumber, forKey: PropertyKey.teamNumber)
        aCoder.encode(events, forKey: PropertyKey.events)
        //aCoder.encode(tournamentInformation, forKey: PropertyKey.tournamentInformation)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let division = aDecoder.decodeObject(forKey: PropertyKey.division) as? String else {
            os_log("Unable to decode the division for a Competitor object", log: OSLog.default, type: .debug)
            return nil
        }
        
        let teamNumber = aDecoder.decodeObject(forKey: PropertyKey.teamNumber) as! Int
        
        let events = aDecoder.decodeObject(forKey: PropertyKey.events) as! [String]
        
        //let tournamentInformation = aDecoder.decodeObject(forKey: PropertyKey.tournamentInformation) as! TournamentInformation
        
        self.init(division: division, teamNumber: teamNumber, events: events)
        
    }
    
    
    
}
