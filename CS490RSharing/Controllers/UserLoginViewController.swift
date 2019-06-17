//
//  UserLoginViewController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 2/6/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserLoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var credLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userLogin(_ sender: Any) {
        
        if let userEmail = emailText.text,let userPassword = passwordText.text{
            Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion:{user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.credLabel.text = firebaseError.localizedDescription
                    return
                }
                
                if user != nil && (user?.user.isEmailVerified)! {
                    self.credLabel.text = "Email verified!"
                    self.performSegue(withIdentifier: "passUser", sender: self)
                }
            })
        }
    }
}
