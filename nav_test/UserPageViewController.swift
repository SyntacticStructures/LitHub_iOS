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
//        keychain.clear()
        if (keychain.get("email") != nil && keychain.get("password") != nil && keychain.get("userID") != nil) {
            emailTextField.text = keychain.get("email")
            mainInstance.userID = keychain.get("userID")
        } else {
            print("Segue to signin")
//            keychain.clear()
//            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("goToSignIn") as! SignInViewController
//            self.presentViewController(vc, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("ShowSignInView", sender: UIButton())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print("view did appear")
        emailTextField.text = keychain.get("email")
        
        
    }
    
    
    
    @IBAction func backToUserViewController(segue: UIStoryboardSegue) {
        let userViewController = segue.sourceViewController as? UserPageViewController
        print("attempting to go to user page")
    }
    
    
}