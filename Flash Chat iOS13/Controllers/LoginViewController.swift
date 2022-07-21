//
//  LoginViewController.swift
//  Flash Chat iOS13
// Created by Арстан on 4/6/22.
//  
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self?.performSegue(withIdentifier: K.loginSegue, sender: sender.self)
                    
                    //                    self?.navigationController?.pushViewController(ChatViewController(), animated: true)
                    
                }
            }
        }
    }
}
