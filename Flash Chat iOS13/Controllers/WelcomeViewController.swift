//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Арстан on 5/6/22.
//

import UIKit
import CLTypingLabel


class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName
        //let titleText = "⚡️FlashChat"
        // var charIndex = 0.0
        //for letter in titleText{
        //print("-")
        //print(0.1 * charIndex)
        //print(letter)
        //Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) {
        //(timer) in
        //self.titleLabel.text?.append(letter)
        //}
        //charIndex += 1
        
        //}
   
    }
    
    
    
    
}
