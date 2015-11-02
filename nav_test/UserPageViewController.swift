//
//  UserPageViewController.swift
//  LitHub
//
//  Created by Vikash Loomba on 11/2/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import UIKit

class UserPageViewController: UIViewController {
    @IBOutlet weak var emailTextField: UILabel!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (keychain.get("email") != nil && keychain.get("password") != nil) {
            emailTextField.text = keychain.get("email")
        } else {
            self.performSegueWithIdentifier("UserAuthenticated", sender: UIButton())
        }
    }
}