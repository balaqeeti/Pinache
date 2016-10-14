//
//  ProfileVC.swift
//  Pinache
//
//  Created by admin on 10/12/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var usernameSetField: FancyField!
    @IBOutlet weak var editProfile: UIStackView!
    @IBOutlet weak var skipForNowDisplay: UIButton!
    
    @IBOutlet weak var imageJett: UIImageView!
    
    var username: String!

    
    var fireUid: String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JETT:\(fireUid)")
        imageJett.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profilePressed(_ sender: AnyObject) {
        imageJett.isHidden = true
        editProfile.isHidden = false
        skipForNowDisplay.isHidden = false
    }
    
    @IBAction func aboutUsPressed(_ sender: AnyObject) {
        editProfile.isHidden = true
        imageJett.isHidden = false
        skipForNowDisplay.isHidden = true
    }
    
    @IBAction func skipForNowPressed(_ sender: AnyObject) {
        if let username = usernameSetField.text {
            if username != "" {
                self.username = username
                guard username.characters.count <= 15 else {
                    print("JETT: Username is too long")
                    return
                }
                print("JETT: Username was set!")
                print("Jett: HERE IT IS \(self.fireUid)")
                // Set up dictionary to post to firebase
                let userInfo = [self.fireUid : username]
                let firebasePost = DataService.ds.REF_USERNAMES.childByAutoId()
                firebasePost.setValue(userInfo)
                usernameSetField.text = username
                performSegue(withIdentifier: "goToFeed", sender: username)
            } else {
                print("JETT: Before you go on, set your username!")
            }
        }
    }
    @IBAction func updatePressed(_ sender: AnyObject) {
        if let username = usernameSetField.text {
            
            // Checking Username in firebase
            DataService.ds.REF_USERNAMES.observe(.value, with: { (snapshot) in
                
                print(snapshot.value)
//                if let snapshot = snapshot.children.allObjects as? Dictionary<NString, NString>{
//                    for snap in snapshot {
//                        print("SNAP: \(snap)")
//                    }
//                }
            })
            
            
            
            
            if username != "" {
            self.username = username
            guard username.characters.count <= 15 else {
                print("JETT: Username is too long")
                return
            }
           
            
            print("JETT: Username was set!")
            let userInfo = [self.fireUid : username]
            let firebasePost = DataService.ds.REF_USERNAMES
            firebasePost.setValue(userInfo)
            usernameSetField.text = username
            performSegue(withIdentifier: "goToFeed", sender: username)
        } else {
            print("JETT: Before you go on, set your username!")
        }
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? FeedVC {
                if let username = sender as? String {
                    destination.username = username
                }
            }
    }
    
}
