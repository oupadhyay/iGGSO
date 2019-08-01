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

struct TournamentInformation: Decodable {
    let B: [Team]
    let C: [Team]
}

struct Team: Decodable {
    let teamNumber: String
    let teamName: String
    let homeroom: String
    let events: [Events]
}

struct Events: Decodable {
    let eventName: String
    let eventNumber: Int
    
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
    
    var selectedDivision : String = ""
    var selectedTeam : String = ""
    var selectedEvents : [String] = []
    
    //var tournamentInformation: TournamentInformation?
    
    //var competitor: Competitor?
    
    
    
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
                let tournamentInformation = try decoder.decode(TournamentInformation.self, from: data)
                
                
                //Populate the arrays for the pickerviews
                for team in tournamentInformation.B
                {
                    teamsB.append(team.teamName + " - " + team.teamNumber)
                }
                
                for team in tournamentInformation.C
                {
                    teamsC.append(team.teamName + " - " + team.teamNumber)
                }
                
                for event in tournamentInformation.B[0].events
                {
                    eventsB.append(event.eventName)
                }
                for event in tournamentInformation.C[0].events
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
        
        continueButton.layer.cornerRadius = 23
        
        
        updateTextFieldStates()
        
        headerColor.layer.shadowOpacity = 1
        headerColor.layer.shadowRadius = 7
        headerColor.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        
        headerColor.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
        
//        continueButton.addTarget(self,
//                           action: #selector(self.saveCompetitor),
//                           for: .touchUpInside)
        
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
            continueButton.layer.shadowRadius = 7
            continueButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
            
            //Yellow Continue Button
            continueButton.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
            
            
            
            
            
        }
    
   
        
    }
}

extension SetupViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0
        {
            return divisions[row]
        } else if selectedDivision == "Division B"
        {
            return teamsB[row]
        } else {
            return teamsC[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
    
    @IBAction func unwindToSetup(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EventsViewController {
            
            let chosenEvents = sourceViewController.chosenEvents
            
            // Add a new meal.
            
            eventsTextField.text = setEventText(events: chosenEvents)
            
            selectedEvents = chosenEvents
            updateTextFieldStates()
          
            
            
            
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "SelectEvents" && selectedDivision == "Division B"){
            
            let navigationController = segue.destination as! UINavigationController
            let tableViewItems = navigationController.topViewController as! EventsViewController
            
            tableViewItems.events = eventsB
        }
        
        if(segue.identifier == "SelectEvents" && selectedDivision == "Division C"){
            
            let navigationController = segue.destination as! UINavigationController
            let tableViewItems = navigationController.topViewController as! EventsViewController
            
            tableViewItems.events = eventsC
        }
    }
    
    
//    @objc private func saveCompetitor()
//    {
//
//        competitor?.division = selectedDivision
//        competitor?.teamNumber = Int(String(selectedTeam.last!))!
//        competitor?.events = selectedEvents
//
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(competitor!, toFile: Competitor.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Competitor information successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save competitor information...", log: OSLog.default, type: .error)
//        }
//    }
//
//    private func loadCompetitor() -> Competitor?
//    {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Competitor.ArchiveURL.path) as? Competitor
//    }
//
    private func setEventText(events: [String]) -> String
    {
        let chosenEventText = events.joined(separator: ", ")

        var truncatedText: String
        if chosenEventText.count > 25 {
            truncatedText = String(chosenEventText.prefix(25))
            truncatedText += "..."
        } else
        {
            truncatedText = chosenEventText

        }

        return truncatedText
    }
}

extension SetupViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        updateTextFieldStates()
        
        if textField == self.divisionTextField {
            eventsTextField.text = ""
            teamTextField.text = ""
            selectedTeam = ""
            selectedEvents = []
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.eventsTextField {
            performSegue(withIdentifier: "SelectEvents", sender: self)
            return false
        } else {
            return true
        }
        
    }
    
    
}




