//
//  SettingsVC.swift
//  Pinache
//
//  Created by admin on 10/15/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var publicView: UIImageView!
    
    @IBOutlet weak var usernameIcon: UIImageView!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var bioIcon: UIImageView!
    
    @IBOutlet weak var bioTextField: UITextView!
    

    
    
    
    
    @IBOutlet weak var selectProfilePictureLabel: UILabel!
    @IBOutlet weak var selectProfilePictureImage: UIImageView!
    
    @IBOutlet weak var quoteView: UIImageView!
    
    @IBOutlet weak var jettImageView: UIImageView!
    
    override func viewDidLoad() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Public Fields
        publicView.isHidden = false
        usernameIcon.isHidden = false
        usernameTextField.isHidden = false
        bioIcon.isHidden = false
        bioTextField.isHidden = false
        
        
        selectProfilePictureImage.isHidden = true
        selectProfilePictureLabel.isHidden = true
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
        //
        selectProfilePictureImage.isHidden = true
        selectProfilePictureLabel.isHidden = true
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
        //
        selectProfilePictureImage.isHidden = false
        selectProfilePictureLabel.isHidden = false
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
        //
        selectProfilePictureImage.isHidden = true
        selectProfilePictureLabel.isHidden = true
        quoteView.isHidden = false
        jettImageView.isHidden = false
    }

    @IBAction func feedIconPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    @IBAction func updateProfilePressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
