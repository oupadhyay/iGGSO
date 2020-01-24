//
//  SetupViewController.swift
//  HUSO
//
//  Created by Asher Noel on 7/29/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import Foundation
import os.log

struct TournamentInformation: Codable
{
    let B: [Team]
    let C: [Team]
}

struct Team: Codable
{
    let teamNumber: String
    let teamName: String
    let homeroom: String
    let events: [Events]
}

struct Events: Codable
{
    let eventName: String
    let eventNumber: Int
    let eventLocation: String
    
    let trialStatus: String
    
    let impoundStatus: String
    let impoundTime: String
    let impoundLocation: String
    
    let eventTime: String
    
    let eventLatitude: String
    let eventLongitude: String
    
    let impoundEventLatitude: String
    let impoundEventLongitude: String
}

class SetupViewController: UIViewController
{
    @IBOutlet weak var divisionTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var eventsTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var headerColor: UIView!
    
    let divisions = ["Division B", "Division C"]
    var teamsB = [String]()
    var teamsC = [String]()
    var eventsB = [String]()
    var eventsC = [String]()
    var tournamentInformation: TournamentInformation?
    
    var selectedDivision : String = ""
    var selectedTeam : String = ""
    var selectedEvents : [String] = []
    
    var homeroom: String = ""
    var teamName: String = ""
    var teamNumber: String = ""
    var detailedEventInformation: [[String]] = []
    
    var competitor = Competitor(division: "selectedDivision", teamName: "teamName", teamNumber: "teamNumber", homeroom: "homeroom", eventInformation: [["detailedEventInformation"]])
    
    var teamPicker = UIPickerView()
    var divisionPicker = UIPickerView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        if let path = Bundle.main.path(forResource: "package", ofType: "json")
        {
            do
            {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                tournamentInformation = try decoder.decode(TournamentInformation.self, from: data)
                
                
                //Populate the arrays for the pickerviews
                for team in tournamentInformation!.B
                {
                    teamsB.append(team.teamName + " - " + team.teamNumber)
                }

                for team in tournamentInformation!.C
                {
                    teamsC.append(team.teamName + " - " + team.teamNumber)
                }
                
                for event in tournamentInformation!.B[0].events
                {
                    eventsB.append(event.eventName)
                    
                }
                for event in tournamentInformation!.C[0].events
                {
                    eventsC.append(event.eventName)
                }
            } catch { print("error") }
        }
        
        createDivisionPicker()
        createTeamPicker()
        
        createToolbarDivision()
        createToolbarTeam()
        
        divisionTextField.delegate = self
        teamTextField.delegate = self
        eventsTextField.delegate = self
        
        updateTextFieldStates()
        
        headerColor.layer.shadowOpacity = 1
        headerColor.layer.shadowRadius = 6
        headerColor.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        headerColor.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
        
        continueButton.layer.shadowColor = UIColor(red: 237/255.0, green: 27/255.0, blue: 52/255.0, alpha: 1).cgColor
        continueButton.isEnabled = false
        continueButton.layer.cornerRadius = 26
    }
    
    //Create Division PickerView
    func createDivisionPicker()
    {
        divisionPicker = UIPickerView()
        divisionPicker.delegate = self
        divisionPicker.backgroundColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)
        divisionPicker.selectRow(0, inComponent: 0, animated: true)
        divisionTextField.inputView = divisionPicker
        divisionPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    //Create Team PickerView
    func createTeamPicker()
    {
        teamPicker = UIPickerView()
        teamPicker.tag = 1
        teamPicker.delegate = self
        teamPicker.backgroundColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)
        
        teamPicker.selectRow(0, inComponent: 0, animated: true)
        
        teamTextField.inputView = teamPicker
    }
    
    func createToolbarDivision()
    {
        let toolBarDivision = UIToolbar()
        toolBarDivision.sizeToFit()
        
        let doneButtonDivision = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SetupViewController.dismissKeyboard))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        doneButtonDivision.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)
        toolBarDivision.setItems([flexibleSpace, doneButtonDivision], animated: false)
        toolBarDivision.isUserInteractionEnabled = true
        
        divisionTextField.inputAccessoryView = toolBarDivision
    }
    
    func createToolbarTeam()
    {
        let toolBarTeam = UIToolbar()
        toolBarTeam.sizeToFit()
        
        let doneButtonTeam = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SetupViewController.dismissKeyboard))
        
         let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        doneButtonTeam.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)
        
        toolBarTeam.setItems([flexibleSpace, doneButtonTeam], animated: false)
        toolBarTeam.isUserInteractionEnabled = true
        
        teamTextField.inputAccessoryView = toolBarTeam
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        updateTextFieldStates()
    }

    private func updateTextFieldStates()
    {
        teamTextField.isUserInteractionEnabled = !selectedDivision.isEmpty
        eventsTextField.isUserInteractionEnabled = !selectedDivision.isEmpty
        
        
        teamTextField.attributedPlaceholder = NSAttributedString(string: teamTextField.attributedPlaceholder!.string,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)])
        eventsTextField.attributedPlaceholder = NSAttributedString(string: eventsTextField.attributedPlaceholder!.string,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)])
        teamTextField.layer.shadowColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1).cgColor
        eventsTextField.layer.shadowColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1).cgColor
        
        
        if (!selectedEvents.isEmpty && !selectedTeam.isEmpty) {
            continueButton.layer.shadowOpacity = 1
            continueButton.layer.shadowRadius = 6
            continueButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
            
            //Yellow Continue Button
            continueButton.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
            
            continueButton.isEnabled = true
        }
        
        if selectedDivision != "" {
             divisionTextField.text = selectedDivision
        }
        if selectedTeam != "" {
            teamTextField.text = selectedTeam
        }
    }
    @IBAction func unwindToSetup(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? EventsViewController
        {
            
            let chosenEvents = sourceViewController.chosenEvents
            
            // Add a new meal.
            
            eventsTextField.text = setEventText(events: chosenEvents)
            
            selectedEvents = chosenEvents
            updateTextFieldStates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if(segue.identifier == "SelectEvents" && selectedDivision == "Division B")
        {
            
            let navigationController = segue.destination as! UINavigationController
            let tableViewItems = navigationController.topViewController as! EventsViewController
            
            tableViewItems.events = eventsB
        }
        
        if(segue.identifier == "SelectEvents" && selectedDivision == "Division C")
        {
            
            let navigationController = segue.destination as! UINavigationController
            let tableViewItems = navigationController.topViewController as! EventsViewController
            
            tableViewItems.events = eventsC
        }
        
        if(segue.identifier == "enterApp")
        {
            buildCompetitorSchedule()
        }
    }
    
    @objc private func buildCompetitorSchedule()
    {
        //Subtract 1 to get the right index
        let range = selectedTeam.range(of: "- ")
        teamNumber = String(selectedTeam[range!.upperBound...])
        let tNAdj = Int(teamNumber)! - 1
        
        if selectedDivision == "Division B"
        {
            //get Team Name and Number
            teamName = tournamentInformation!.B[tNAdj].teamName
            homeroom = tournamentInformation!.B[tNAdj].homeroom
            
            //Build Matrix with event numbers based off event Names.
            var eventNumbers: [Int] = []
            for event in selectedEvents {
                eventNumbers.append(eventsB.firstIndex(of: event)!)
            }
            
            //Append detailedEventInformation array with event time AND impound time/locations.
            for index in eventNumbers
            {
                //Add Event Name, Location, and Time to an array
                var singularEventData: [String] = []
                singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventName)
                singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventLocation)
                
                //If the time is 1:00 AM, then display it as NA
                if tournamentInformation!.B[tNAdj].events[Int(index)].eventTime == "1:00 AM" {
                    singularEventData.append("N/A AM")
                } else {
                    singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventTime)
                }
                
                singularEventData.append(convertTime(hhMMa: tournamentInformation!.B[tNAdj].events[Int(index)].eventTime))
                singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].trialStatus)
                singularEventData.append("EVENT")
                
                singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventLatitude)
                singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventLongitude)
                
                detailedEventInformation.append(singularEventData)
                
                
                // Account for impound events.
                if tournamentInformation!.B[tNAdj].events[Int(index)].impoundStatus == "Yes"
                {
                    var impoundEventData: [String] = []
                    impoundEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventName)
                    impoundEventData.append( tournamentInformation!.B[tNAdj].events[Int(index)].impoundLocation)
                    impoundEventData.append( tournamentInformation!.B[tNAdj].events[Int(index)].impoundTime)
                    impoundEventData.append(convertTime(hhMMa: impoundEventData[2]))
                    impoundEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].trialStatus)
                    impoundEventData.append("IMPOUND")
                    
                    
                    impoundEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].impoundEventLatitude)
                    impoundEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].impoundEventLongitude)
                    detailedEventInformation.append(impoundEventData)
                }
            }
        } else {
            //get Team Name and Number
            teamName = tournamentInformation!.C[tNAdj].teamName
            homeroom = tournamentInformation!.C[tNAdj].homeroom
            
            //Build Matrix with event numbers based off event Names.
            var eventNumbers: [Int] = []
            for event in selectedEvents
            {
                eventNumbers.append(eventsC.firstIndex(of: event)!)
            }
            
            //Append detailedEventInformation array with event time AND impound time/locations.
            for index in eventNumbers
            {
                //Add Event Name, Location, Time, 24 hour time, and trial status to an array
                var singularEventData: [String] = []
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventName)
                
                if tournamentInformation!.C[tNAdj].events[Int(index)].eventName == "Chem Lab" || tournamentInformation!.C[tNAdj].events[Int(index)].eventName == "Forensics" {
                    detailedEventInformation.append(["Lab Safety (Chem Events)", "Science Center 212", "7:00 AM", "700", "No", "HUSO", "42.376492", "-71.116657"])
                }
                
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventLocation)
                
                //If the time is 1:00 AM, then display it as NA
                if tournamentInformation!.C[tNAdj].events[Int(index)].eventTime == "1:00 AM" {
                    singularEventData.append("N/A AM")
                } else {
                    singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventTime)
                }
                
                singularEventData.append(convertTime(hhMMa: tournamentInformation!.C[tNAdj].events[Int(index)].eventTime))
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].trialStatus)
                singularEventData.append("EVENT")
                
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventLatitude)
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventLongitude)
                
                
                detailedEventInformation.append(singularEventData)
                
                // Account for impound events.
                if tournamentInformation!.C[tNAdj].events[Int(index)].impoundStatus == "Yes"
                {
                    var impoundEventData: [String] = []
                    impoundEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventName)
                    impoundEventData.append( tournamentInformation!.C[tNAdj].events[Int(index)].impoundLocation)
                    impoundEventData.append( tournamentInformation!.C[tNAdj].events[Int(index)].impoundTime)
                    impoundEventData.append(convertTime(hhMMa: impoundEventData[2]))
                    impoundEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].trialStatus)
                    impoundEventData.append("IMPOUND")
                    
                    impoundEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].impoundEventLatitude)
                    impoundEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].impoundEventLongitude)
                    
                    detailedEventInformation.append(impoundEventData)
                }
            }
        }
    
        
        
        //Add Award Ceremony For division
        if selectedDivision == "Division B" {
            detailedEventInformation.append(["Check-In", "Sever Hall 110", "6:00 AM", "600", "No", "HUSO", "42.374559","-71.115446"])
            detailedEventInformation.append(["Lab Safety Training", "Science Center 212", "7:00 AM", "700", "No", "HUSO", "42.376492", "-71.116657"])
            detailedEventInformation.append(["Awards Ceremony", "Science Center B", "3:00 PM", "1500", "No", "HUSO", "42.376492", "-71.116657"])
        } else if selectedDivision == "Division C" {
        
        
            detailedEventInformation.append(["Awards Ceremony", "Science Center B", "5:30 PM", "1730", "No", "HUSO", "42.376492", "-71.116657"])
        }
        
        //Order the detailed event Information array by time of the event/impound.
        detailedEventInformation = detailedEventInformation.sorted(by: {(Int($0[3])!) < (Int($1[3])!)})
        
       
        
        saveCompetitorSchedule()
    }
    
    @objc private func saveCompetitorSchedule()
    {
        competitor?.division = selectedDivision
        competitor?.teamName = teamName
        competitor?.teamNumber = teamNumber
        competitor?.homeroom = homeroom
        competitor?.eventInformation = detailedEventInformation
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(competitor!, toFile: Competitor.ArchiveURL.path)
        
        if isSuccessfulSave
        {
            os_log("Competitor information successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save competitor information...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadCompetitor() -> Competitor?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Competitor.ArchiveURL.path) as? Competitor
    }
    
    
    private func setEventText(events: [String]) -> String
    {
        let chosenEventText = events.joined(separator: ", ")
        
        var truncatedText: String
        if chosenEventText.count > 25 {
            truncatedText = String(chosenEventText.prefix(25))
            truncatedText += "..."
        }
        else
        {
            truncatedText = chosenEventText
        }
        
        return truncatedText
    }
    
    
    private func convertTime(hhMMa: String) -> String
    {
        let dateAsString = hhMMa
        let dateFormatter = DateFormatter()
    
        //Convert times that have HH format
        dateFormatter.dateFormat = "hh:mm a"
        var date = dateFormatter.date(from: dateAsString)
            
        //Convert times that have H format
        if dateAsString.count <= 7
        {
            dateFormatter.dateFormat = "h:mm a"
            date = dateFormatter.date(from: dateAsString)
           
        }
        
        dateFormatter.dateFormat = "HH:mm"
        
        var date24: String
        if let date = date {
            date24 = dateFormatter.string(from: date)
        } else {
            date24 = "00:30"
        }
        
        let leftTime = String(Int(String(date24.prefix(2)))!)
       
        if String(Int(String(date24.suffix(2)))!) == "0" {
            let rightTime = "00"
            return leftTime + rightTime
        } else {
            let rightTime = String(Int(String(date24.suffix(2)))!)
            return leftTime + rightTime
        }
        
    }
}

extension SetupViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return divisions.count
        }
        else if selectedDivision == "Division B"
        {
            return teamsB.count
        }
        else
        {
            return teamsC.count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if pickerView.tag == 0
        {
          
            
            return divisions[row]
        } else if selectedDivision == "Division B"
        {
            
            
            return teamsB[row]
        } else
        {
           
            
            return teamsC[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        
        if pickerView.tag == 0
        {
            selectedDivision = divisions[row]
            divisionTextField.text = selectedDivision
        } else if selectedDivision == "Division B"
        {
            selectedTeam = teamsB[row]
            teamTextField.text = selectedTeam
        } else
        {
        
            selectedTeam = teamsC[row]
            teamTextField.text = selectedTeam
        }
        
    }
    
    
}


extension SetupViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        updateTextFieldStates()
        
        if textField == self.divisionTextField
        {
            eventsTextField.text = ""
            teamTextField.text = ""
            selectedTeam = ""
            selectedEvents = []
        }
        

        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if textField == self.eventsTextField
        {
            performSegue(withIdentifier: "SelectEvents", sender: self)
            return false
        }
        
        if textField == self.divisionTextField
        {
            
            selectedDivision = "Division B"
           
            return true
        }
    
        if textField == self.teamTextField  && selectedDivision == "Division B"
        {
            selectedTeam = teamsB[0]
       
            return true
    
        }
    
        if textField == self.teamTextField  && selectedDivision == "Division C"
        {
            selectedTeam = teamsC[0]
           
            return true
    
        } else {
            return true
        }
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}





