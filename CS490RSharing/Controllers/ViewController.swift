//
//  ViewController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 2/1/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userInfoSubmit: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func enterApp(_ sender: Any) {
        
      performSegue(withIdentifier: "returnHome", sender: self)
            
    }
}



/*
 @IBAction func createAccount(_ sender: Any) {
 if let userEmail = usernameField.text),let userPassword = passwordField.text{
 Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion:{user,error in
 if let firebaseError = error{
 print(firebaseError.localizedDescription)
 return
 }
 print("Account successfully created.")
 self.credLabel.text = "Account successfully created! Please sign in!"
 //self.showLoginScreen()
 })
 
 }
 
 }
 */
