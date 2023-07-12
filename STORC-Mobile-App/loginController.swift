//
//  loginController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/12/23.
//

import UIKit
import SwiftUI

class loginController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    let userInfo = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //When user does not have account send them to sign up page
    @IBAction func sendToSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    //When submit button is pressed check conditions then send to main
    @IBAction func sendToMain(_ sender: UIButton) {
        let userName = userInfo.string(forKey: "Username")
        let userPass = userInfo.string(forKey: "Password")
        if(userName == usernameField.text && userPass == passwordField.text){
            self.performSegue(withIdentifier: "sendToMain", sender: self)

        }else{
            print("There was an error and either username or password isnt correct learn how to handle errors")
        }
    }
}
