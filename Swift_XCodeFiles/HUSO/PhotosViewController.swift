//
//  PhotosViewController.swift
//  HUSO
//
//  Created by Asher Noel on 8/3/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import MessageUI


class PhotosViewController: UIViewController, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var selectImage: UIImageView!
    @IBOutlet var submitButton: UIButton!
    
    var competitor: Competitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        competitor = loadCompetitor()
        submitButton.addTarget(self, action: #selector(sendMail), for: .touchUpInside)
        submitButton.isEnabled = false
    }
    
    //Show the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //Select an image when the selector is tapped.
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Submit the photo when the button is clicked.
    @objc func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setToRecipients(["team@harvardscioly.org"])
            mail.setSubject("Pre-Award Ceremony Photo Submission")
            
            let teamName = competitor?.teamName
            
            mail.setMessageBody("Hello Harvard Scioly, \n\n This is a pre-award ceremony photo submission from \(teamName!) High School.", isHTML: false)
            let imageData: NSData = selectImage.image!.pngData()! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName.png")
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func loadCompetitor() -> Competitor?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Competitor.ArchiveURL.path) as? Competitor
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set selectImage to display the selected image.
        selectImage.image = selectedImage
        submitButton.isEnabled = true
        submitButton.layer.shadowOpacity = 1
        submitButton.layer.shadowRadius = 3
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        submitButton.layer.shadowColor = UIColor(red: 252/255.0, green: 179/255.0, blue: 21/255.0, alpha: 1).cgColor
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

}
