//
//  CreateAccountViewController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 2/6/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!    
    @IBOutlet weak var credLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createUser(_ sender: Any) {
        if let userEmail = emailText.text,let userPassword = passwordText.text{
            Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion:{user,error in
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    self.credLabel.text = firebaseError.localizedDescription
                    return
                }
                print("Account successfully created.")
                self.credLabel.text = "Account successfully created! Please verify your email."
                self.sendVerificationMail()
                self.showLoginScreen()
            })
            
        }
    }
    private var authUser: User?{
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    self.credLabel.text = firebaseError.localizedDescription
                    return
                }
                print("email verification complete")
                self.credLabel.text = "email verification complete, please login"
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
            self.credLabel.text = "User is already verified"
        }
    }
    
    func showLoginScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let LoginViewController:LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(LoginViewController, animated: true ,completion: nil)
    }
    
   

}
