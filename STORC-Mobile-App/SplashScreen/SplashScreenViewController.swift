//
//  SplashScreenViewController.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 6/20/23.
//

import UIKit
import RevealingSplashView

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let splashView = RevealingSplashView(iconImage: UIImage(named: "STORCWhite")!, iconInitialSize: CGSize(width: 75, height: 75), backgroundColor: UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0))
        
        splashView.duration = 2
        
        self.view.addSubview(splashView)
        
        splashView.playTwitterAnimation(){
            print("Completed")
            self.performSegue(withIdentifier: "splashToTabBarController", sender: self)
        }
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
