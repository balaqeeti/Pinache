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
    @IBOutlet weak var selectProfilePictureImage: CircleView!
    
    @IBOutlet weak var quoteView: UIImageView!
    
    @IBOutlet weak var jettImageView: UIImageView!
    
    
    
    var imagePicker: UIImagePickerController!
    var uid: String!
    var profilePictureUrl: String!
    
    var profilePictureIsAvailableForDownload: Bool!
    var isInMiddleOfSelecting = false
    
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
        
        
        // Show existing username in the username text field
        let _userRef = DataService.ds.REF_USER_CURRENT.child("username")
        
        _userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                print("JETT: Displaying placeholder text")
            } else {
               self.usernameTextField.text = snapshot.value as? String
                print("JETT: \(self.usernameTextField.text) sec")
            }
        })
        super.viewDidLoad()

        // Check if a profile picture is in Firebase

        let _profilePictureRef = DataService.ds.REF_USER_CURRENT.child("profile-picture-url")
        
        _profilePictureRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                // self.profilePictureUrl = ""
                print("JETT: Profile Picture not available")
                self.profilePictureIsAvailableForDownload = false
                
            } else {
                self.profilePictureUrl = snapshot.value as? String
                print("JETT: profile picture is available")
                self.profilePictureIsAvailableForDownload = true
            }
        })

        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Download existing profile picture to appear in placeholder image
        
        if profilePictureIsAvailableForDownload! && !isInMiddleOfSelecting {
        let profilePictureRef = FIRStorage.storage().reference(forURL: self.profilePictureUrl)
        profilePictureRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print("JETT: Unable to download image from Firebase")
            } else {
                print("JETT: Image downloaded from Firebase ")
                if let imageData = data {
                    if let img = UIImage(data: imageData){
                        self.selectProfilePictureImage.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.profilePictureUrl as NSString)
                    }
                }
            }
            
        })
    }
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
        self.isInMiddleOfSelecting = true
        print("JETT: User is trying to upload profile picture")
        present(imagePicker, animated: true, completion: nil)
        

    }
    
    @IBAction func updateProfilePicturePressed(_ sender: AnyObject) {
        
        // Experimental Method
        self.isInMiddleOfSelecting = false
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
