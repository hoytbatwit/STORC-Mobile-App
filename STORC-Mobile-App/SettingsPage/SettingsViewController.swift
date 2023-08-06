//
//  SettingsViewController.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/30/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func signOutButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SettingsToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
