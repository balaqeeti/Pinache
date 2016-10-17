//
//  SettingsVC.swift
//  Pinache
//
//  Created by admin on 10/15/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var publicView: UIImageView!
    
    @IBOutlet weak var usernameIcon: UIImageView!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var bioIcon: UIImageView!
    
    @IBOutlet weak var bioTextField: UITextView!
    
    @IBOutlet weak var updateProfileView: UIImageView!

    @IBOutlet weak var updateProfilePicture: UIImageView!
    
    @IBOutlet weak var selectProfilePictureLabel: UILabel!
    @IBOutlet weak var selectProfilePictureImage: UIImageView!
    
    @IBOutlet weak var quoteView: UIImageView!
    
    @IBOutlet weak var jettImageView: UIImageView!
    
    
    
    var imagePicker: UIImagePickerController!
    var uid: String!
    
    override func viewDidLoad() {
        print("JETT \(uid)")
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Public Fields
        publicView.isHidden = false
        usernameIcon.isHidden = false
        usernameTextField.isHidden = false
        bioIcon.isHidden = false
        bioTextField.isHidden = false
        updateProfileView.isHidden = false
        
        selectProfilePictureImage.isHidden = true
        selectProfilePictureLabel.isHidden = true
        updateProfilePicture.isHidden = true
        quoteView.isHidden = true
        jettImageView.isHidden = true
        // TODO: Hide other tabs
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func profileTabPressed(_ sender: AnyObject) {
        // Public Fields
        publicView.isHidden = false
        usernameIcon.isHidden = false
        usernameTextField.isHidden = false
        bioIcon.isHidden = false
        bioTextField.isHidden = false
        updateProfileView.isHidden = false
        //
        selectProfilePictureImage.isHidden = true
        selectProfilePictureLabel.isHidden = true
        updateProfilePicture.isHidden = true
        quoteView.isHidden = true
        jettImageView.isHidden = true
    }
    @IBAction func imageTabPressed(_ sender: AnyObject) {
        // Public Fields
        publicView.isHidden = true
        usernameIcon.isHidden = true
        usernameTextField.isHidden = true
        bioIcon.isHidden = true
        bioTextField.isHidden = true
        updateProfileView.isHidden = true
        //
        selectProfilePictureImage.isHidden = false
        selectProfilePictureLabel.isHidden = false
        updateProfilePicture.isHidden = false
        quoteView.isHidden = true
        jettImageView.isHidden = true
    }
    @IBAction func aboutUsPressed(_ sender: AnyObject) {
        // Public Fields
        publicView.isHidden = true
        usernameIcon.isHidden = true
        usernameTextField.isHidden = true
        bioIcon.isHidden = true
        bioTextField.isHidden = true
        updateProfileView.isHidden = true
        //
        selectProfilePictureImage.isHidden = true
        selectProfilePictureLabel.isHidden = true
        updateProfilePicture.isHidden = true
        quoteView.isHidden = false
        jettImageView.isHidden = false
    }

    @IBAction func feedIconPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    @IBAction func updateProfilePressed(_ sender: AnyObject) {
        if usernameTextField.text != "" {
            let username = usernameTextField.text!
            let userData = ["username" : username]
            DataService.ds.createFirebaseDBUser(uid: uid, userData: userData)
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectProfilePictureImage.image = image
           // imageSelected = true
        } else {
            print("JETT: A valid image wasn't selected" )
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfileImagePressed(_ sender: AnyObject) {
        
        print("JETT: User is trying to upload profile picture")
        present(imagePicker, animated: true, completion: nil)
        

    }
    
    @IBAction func updateProfilePicturePressed(_ sender: AnyObject) {
        
        // Experimental Method
        if let img = selectProfilePictureImage.image {
            if let imgData = UIImageJPEGRepresentation(img, 0.2){
                
                let imgUid = NSUUID().uuidString
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                DataService.ds.REF_PROFILE_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("JETT: Unable to upload image to Firebase storage")
                    } else {
                        print("JETT: Successfully uploaded image to firebase storage")
                            let downloadURL = metadata?.downloadURL()?.absoluteString
                                            if let url = downloadURL {
                                                let userData = ["profile-picture-url" : url]
                                                DataService.ds.createFirebaseDBUser(uid: self.uid, userData: userData)
                                                self.performSegue(withIdentifier: "goToFeed", sender: url)
                                                
                                            }
                    }
                    
                }
            }
            
            
        }

        
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? FeedVC {
//            if let url = sender as? String {
//                destination.profilePictureUrl = url
//            }
//        }
//    }

}
