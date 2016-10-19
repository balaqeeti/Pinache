//
//  LoadingProfileVC.swift
//  Pinache
//
//  Created by admin on 10/19/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit

class LoadingProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "goToProfile", sender: nil)
    }

}

