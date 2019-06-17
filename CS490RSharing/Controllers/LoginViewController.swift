//
//  LoginViewController.swift
//  
//
//  Created by Jonathan G. Dzialo on 2/6/19.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        performSegue(withIdentifier: "creationSegue", sender: self)
    }
    @IBAction func loginAccount(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
