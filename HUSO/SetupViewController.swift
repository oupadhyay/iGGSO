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
    
    //var competitor = Competitor(division: "default", teamNumber: 1, events: ["default"], teamInformation: Team?)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Load the tournament information JSON file
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
        
        continueButton.layer.cornerRadius = 26
        
        
        updateTextFieldStates()
        
        headerColor.layer.shadowOpacity = 1
        headerColor.layer.shadowRadius = 6
        headerColor.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        
        headerColor.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
        
        continueButton.layer.shadowColor = UIColor(red: 237/255.0, green: 27/255.0, blue: 52/255.0, alpha: 1).cgColor
        
        continueButton.isEnabled = false
        
        
    
        
        //        if let competitor = loadCompetitor() {
        //            divisionTextField.text = competitor.division
        //            teamTextField.text = String(competitor.teamNumber)
        //
        //            //Change the above to team name and number
        //
        //
        //            eventsTextField.text = setEventText(events: competitor.events)
        //            //tournamentInformation = competitor.tournamentInformation
        //        }
        
        
        
        
        
    }
    
    //Create Division PickerView
    func createDivisionPicker()
    {
        let divisionPicker = UIPickerView()
        divisionPicker.delegate = self
        
        divisionPicker.backgroundColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)
        
        divisionTextField.inputView = divisionPicker
    }
    
    //Create Team PickerView
    func createTeamPicker()
    {
        let teamPicker = UIPickerView()
        teamPicker.tag = 1
        teamPicker.delegate = self
        
        teamPicker.backgroundColor = UIColor(red: 147.0/255, green: 161.0/255, blue: 173.0/255, alpha: 1)
        
        
        teamTextField.inputView = teamPicker
    }
    
    func createToolbarDivision()
    {
        let toolBarDivision = UIToolbar()
        toolBarDivision.sizeToFit()
        
        let doneButtonDivision = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SetupViewController.dismissKeyboard))
        
        doneButtonDivision.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)
        toolBarDivision.setItems([doneButtonDivision], animated: false)
        toolBarDivision.isUserInteractionEnabled = true
        
        divisionTextField.inputAccessoryView = toolBarDivision
    }
    
    func createToolbarTeam()
    {
        let toolBarTeam = UIToolbar()
        toolBarTeam.sizeToFit()
        
        let doneButtonTeam = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SetupViewController.dismissKeyboard))
        
        doneButtonTeam.tintColor = UIColor(red: 0.644305, green: 0.0630083, blue: 0.204552, alpha:1)
        
        toolBarTeam.setItems([doneButtonTeam], animated: false)
        toolBarTeam.isUserInteractionEnabled = true
        
        teamTextField.inputAccessoryView = toolBarTeam
    }
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        updateTextFieldStates()
    }
    
    //MARK: Private Methods
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
            //GREEN UPON COMPLETION
            //            divisionTextField.layer.shadowColor = UIColor(red: 77.0/255, green: 184.0/255, blue: 72.0/255, alpha: 1).cgColor
            //            teamTextField.layer.shadowColor = UIColor(red: 77.0/255, green: 184.0/255, blue: 72.0/255, alpha: 1).cgColor
            //            eventsTextField.layer.shadowColor = UIColor(red: 77.0/255, green: 184.0/255, blue: 72.0/255, alpha: 1).cgColor
            
            //Make Continue Button Beautiful
            continueButton.layer.shadowOpacity = 1
            continueButton.layer.shadowRadius = 6
            continueButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
            
            //Yellow Continue Button
            continueButton.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
            
            continueButton.isEnabled = true
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
            let barViewControllers = segue.destination as! BaseTabBarController
            let schedule = barViewControllers.viewControllers?[1] as! ScheduleViewController
            
            buildCompetitorSchedule()
            //schedule.competitor = competitor
        }
    }
    
    @objc private func buildCompetitorSchedule()
    {
        //Subtract 1 to get the right index
        teamNumber = String(selectedTeam.last!)
        print(teamNumber)
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
                singularEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventTime)
                singularEventData.append(convertTime(hhMMa: singularEventData[2]))
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].trialStatus)
                singularEventData.append("EVENT:")
                
                detailedEventInformation.append(singularEventData)
                
                
                // Account for impound events.
                if tournamentInformation!.B[tNAdj].events[Int(index)].impoundStatus == "Yes"
                {
                    var impoundEventData: [String] = []
                    impoundEventData.append(tournamentInformation!.B[tNAdj].events[Int(index)].eventName)
                    impoundEventData.append( tournamentInformation!.B[tNAdj].events[Int(index)].impoundLocation)
                    impoundEventData.append( tournamentInformation!.B[tNAdj].events[Int(index)].impoundTime)
                    impoundEventData.append(convertTime(hhMMa: impoundEventData[2]))
                    impoundEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].trialStatus)
                    impoundEventData.append("IMPOUND:")
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
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventLocation)
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].eventTime)
                singularEventData.append(convertTime(hhMMa: singularEventData[2]))
                singularEventData.append(tournamentInformation!.C[tNAdj].events[Int(index)].trialStatus)
                singularEventData.append("EVENT")
                
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
                    
                    detailedEventInformation.append(impoundEventData)
                }
            }
        }
    
        //Order the detailed event Information array by time of the event/impound.
        detailedEventInformation = detailedEventInformation.sorted(by: {(Int($0[3])!) < (Int($1[3])!)})
        
        print("checkpoint")
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
        let date24 = dateFormatter.string(from: date!)
        
        let leftTime = String(Int(String(date24.prefix(2)))!)
        let rightTime = String(Int(String(date24.suffix(2)))!*100/60)
        let intDate = leftTime + rightTime
        
        return intDate
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
        } else
        {
            return true
        }
    }
}




