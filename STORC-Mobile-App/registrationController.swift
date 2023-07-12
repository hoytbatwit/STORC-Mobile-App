//
//  Login:Sign-UpController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/11/23.
//

import UIKit
import SwiftUI

class registrationController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    let userInfo = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let pass = passwordField.text
        let passConf = confirmPasswordField.text
        let user = usernameField.text
        if(pass == passConf){
            userInfo.set(pass, forKey: "Password")
            userInfo.set(user, forKey: "Username")
            self.performSegue(withIdentifier: "sendToLogin", sender: self)
        }else{
            print("The passwords do not mach need to handle this error")
        }
    }
}
