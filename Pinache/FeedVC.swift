//
//  FeedVC.swift
//  Pinache
//
//  Created by admin on 10/10/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageAdd: UIImageView!
    
   @IBOutlet weak var captionField: FancyField!

   
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    var username: String!
    var uid: String!
    var profilePictureUrl: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("JETT: \(uid)")
        print("JETT: \(username)")

        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

       
        let _userRef = DataService.ds.REF_USER_CURRENT.child("username")
        
        _userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.username = "New User"
                print("JETT: \(self.username) lolz")
            } else {
                self.username = snapshot.value as? String
                print("JETT: \(self.username) sec")
            }
        })
        
        

        
        let _uidRef = DataService.ds.REF_USER_CURRENT.child("uid")
        
        _uidRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.uid = "No UID"
                print("JETT: \(self.uid) lolz")
            } else {
                self.uid = snapshot.value as? String
                print("JETT: \(self.uid) sec")
            }
        })
        
        let _profilePictureRef = DataService.ds.REF_USER_CURRENT.child("profile-picture-url")
        
        _profilePictureRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.profilePictureUrl = ""
                print("JETT: Profile Picture not set")
            } else {
                self.profilePictureUrl = snapshot.value as? String
                print("JETT: profile picture is set")
            }
        })

        
        
        
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
            cell.configureCell(post: post, img: img)
            return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
       
            return PostCell()
        }
        // WORKING BIT
//        let post = posts[indexPath.row]
//        print("JETT: Hahaha here it is: \(post.caption)")
//        
//        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    
}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("JETT: A valid image wasn't selected" )
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func addImageTapped(_ sender: AnyObject) {
    
        present(imagePicker, animated: true, completion: nil)
    }
   
    
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else {
            print("JETT: Caption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("JETT: An image must be selected")
            return
        }
        
        guard let userName = username, userName != "New User" else {
            print("JETT: Username must be set")
            return
        }
        guard let profilePictureUrl = profilePictureUrl, profilePictureUrl != "" else {
            print("JETT: Please set your profile pic before posting!")
            return
        }
    
        self.dismissKeyboard()
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("JETT: Unable to upload image to Firebase storage")
                } else {
                    print("JETT: Successfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                }
            }
            
        }
    }
}
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageUrl": imgUrl,
            "likes": 0,
            "username": self.username,
            "profile-picture-url": self.profilePictureUrl
        ]
  
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
    
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "Camera-Photo")
        tableView.reloadData()
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JETT: \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    @IBAction func settingsTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToSettings", sender: uid)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SettingsVC {
            if let uid = sender as? String {
                destination.uid = uid
            }
        }
    }

}
