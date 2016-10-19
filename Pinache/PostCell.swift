//
//  PostCell.swift
//  Pinache
//
//  Created by admin on 10/10/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import Firebase



class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLblDisplay: UIButton!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var goToProfileUid: String!
    //var usernameRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 3.0
        
        // Like Gesture Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        // Username Tap Gesture Recognizer
       
//        let usernameTap = UITapGestureRecognizer(target: self, action: #selector(usernameTapped))
//        usernameTap.numberOfTapsRequired = 1
//        usernameLbl.addGestureRecognizer(usernameTap)
//        usernameLbl.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
       
        caption.text = post.caption
        
        likesLbl.text = "\(post.likes)"
        
        usernameLblDisplay.setTitle(post.username, for: .normal)
        
        print("JETT: Image URL: \(post.profilePictureUrl)")

        
        
        
        
        if img != nil {
            self.postImg.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("JETT: Unable to download image from Firebase")
                    } else {
                        print("JETT: Image downloaded from Firebase ")
                        if let imageData = data {
                            if let img = UIImage(data: imageData){
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            }
                        }
                    }
        
            })
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
        //Download the profile picture
        
            let profilePictureRef = FIRStorage.storage().reference(forURL: post.profilePictureUrl)
            profilePictureRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JETT: Unable to download image from Firebase")
                } else {
                    print("JETT: Image downloaded from Firebase pp")
                    if let imageData = data {
                        if let img = UIImage(data: imageData){
                            self.profileImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.profilePictureUrl as NSString)
                        }
                    }
                }
                
            })
        

        
        
//        let _userRef = DataService.ds.REF_USER_CURRENT.child("username")
//        
////        _userRef.observeSingleEvent(of: .value, with: { (snapshot) in
////            if let _ = snapshot.value as? NSNull {
////                self.usernameLbl.text = "New User"
////                print("JETT: \(self.usernameLbl.text) lolz")
////            } else {
////                self.usernameLbl.text = snapshot.value as? String
////                print("JETT: \(self.usernameLbl.text) sec")
////            }
////        })
//        
      
        
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    
    @IBAction func usernameTapped(_ sender: AnyObject) {
        let usernameLookupKey = usernameLblDisplay.currentTitle!
        print("JETT: here is the lookup key \(usernameLookupKey)")
        let usernameRef = DataService.ds.REF_USERNAMES.child("\(usernameLookupKey)")
        
        usernameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                print("JETT: How are you accessing this??")
            } else {
                print("JETT: Got the UID!: \(snapshot.value)")
                let goToProfileUid = snapshot.value! as! String
                // Segue from story board
                DataService.ds.createFirebaseDBUserToView(uid: goToProfileUid)
                print("JETT: UID: \(goToProfileUid) Name: \(usernameLookupKey)")
                
                
            }
        })
    }
    
    
//    func usernameTapped(sender: UITapGestureRecognizer) {
//        let usernameLookupKey = usernameLblDisplay.currentTitle
//        print("JETT: here is the lookup key \(usernameLookupKey)")
//        let usernameRef = DataService.ds.REF_USERNAMES.child("\(usernameLookupKey)")
//        
//        usernameRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                print("JETT: How are you accessing this??")
//            } else {
//                print("JETT: Got the UID!: \(snapshot.value)")
//                self.goToProfileUid = snapshot.value! as! String
//        
//            }
//        })
//
//    }

}
