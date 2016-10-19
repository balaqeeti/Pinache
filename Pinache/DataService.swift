//
//  DataService.swift
//  Pinache
//
//  Created by admin on 10/10/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()



class DataService {
    
    static let ds = DataService()
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_USERNAMES = DB_BASE.child("usernames")
    //private var _REF_PROFILE_TO_VIEW = DB_BASE.child("current")
    //Storage Referenes
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-pics")
    
    //DB
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_USERNAMES: FIRDatabaseReference {
        return _REF_USERNAMES
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
//    var REF_PROFILE_TO_VIEW : FIRDatabaseReference {
//        return _REF_PROFILE_TO_VIEW
//    }
    // Storage
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseDBUsername(uid: String, userData: String) {
        let userData = [userData: uid]
        REF_USERNAMES.updateChildValues(userData)
    }
    
    func createFirebaseDBUserToView(uid: String) {
        let userData = ["profile-to-view" : uid]
        REF_BASE.updateChildValues(userData)
    }
    
    
    
}
