//
//  ProfileVC.swift
//  Pinache
//
//  Created by admin on 10/18/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    var uid: String!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileBio: UITextView!
    
    //var profileUid: String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _userRef = DataService.ds.REF_BASE.child("profile-to-view")
        
        _userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                print("JETT: Database does not have 'profile-to-view'")
            } else {
                let profileUid = snapshot.value as? String
                print("JETT: \(profileUid) sec")
                // Set Username
                let _usernameRef = DataService.ds.REF_USERS.child(profileUid!).child("username")
                
                _usernameRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNull {
                        print("JETT: Database does not have 'profile-to-view'")
                    } else {
                        self.profileUsername.text = snapshot.value as? String
                        print("JETT: \(self.profileUsername.text) sec")
                    }
                })
                
                let _bioRef = DataService.ds.REF_USERS.child(profileUid!).child("biodata")
                
                _bioRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNull {
                        print("JETT: Database does not have 'profile-to-view'")
                    } else {
                        self.profileBio.text = snapshot.value as? String
                        print("JETT: \(self.profileBio.text) sec")
                    }
                })
                
                let _picRef = DataService.ds.REF_USERS.child(profileUid!).child("profile-picture-url")
                
                _picRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNull {
                        print("JETT: Database does not have 'profile-to-view'")
                    } else {
                        let pictureUrl = snapshot.value as? String
                        print("JETT: \(pictureUrl) sec")
                        
                        
                        let profilePictureRef = FIRStorage.storage().reference(forURL: pictureUrl!)
                        profilePictureRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("JETT: Unable to download image from Firebase")
                            } else {
                                print("JETT: Image downloaded from Firebase ")
                                if let imageData = data {
                                    if let img = UIImage(data: imageData){
                                        self.profilePicture.image = img
                                        //                                FeedVC.imageCache.setObject(img, forKey: self.profilePictureUrl as NSString)
                                    }
                                }
                            }
                            
                        })
                    }
                })
                
            }
        })
        
//        let _usernameRef = DataService.ds.REF_USERS.child(profileUid).child("username")
//        
//        _usernameRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                print("JETT: Database does not have 'profile-to-view'")
//            } else {
//                self.profileUsername.text = snapshot.value as? String
//                print("JETT: \(self.profileUsername.text) sec")
//            }
//        })
        
//        let _bioRef = DataService.ds.REF_USERS.child(profileUid).child("biodata")
//        
//        _bioRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                print("JETT: Database does not have 'profile-to-view'")
//            } else {
//                self.profileBio.text = snapshot.value as? String
//                print("JETT: \(self.profileBio.text) sec")
//            }
//        })
//        
//        let _picRef = DataService.ds.REF_USERS.child(profileUid).child("profile-picture-url")
//        
//        _picRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                print("JETT: Database does not have 'profile-to-view'")
//            } else {
//                let pictureUrl = snapshot.value as? String
//                print("JETT: \(pictureUrl) sec")
//                
//                
//                let profilePictureRef = FIRStorage.storage().reference(forURL: pictureUrl!)
//                profilePictureRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
//                    if error != nil {
//                        print("JETT: Unable to download image from Firebase")
//                    } else {
//                        print("JETT: Image downloaded from Firebase ")
//                        if let imageData = data {
//                            if let img = UIImage(data: imageData){
//                                self.profilePicture.image = img
//                                //                                FeedVC.imageCache.setObject(img, forKey: self.profilePictureUrl as NSString)
//                            }
//                        }
//                    }
//                    
//                })
//            }
//        })
        
    }
    

        
        
}
    
