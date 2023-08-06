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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
