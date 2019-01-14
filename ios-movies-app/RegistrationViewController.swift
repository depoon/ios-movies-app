//
//  RegistrationViewController.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 27/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth

class RegistrationViewController: UIViewController {
 
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    static func initFromStoryboard() -> RegistrationViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registration"
        self.registerButton.addTarget(self, action: #selector(self.didTapRegister), for: .touchUpInside)
        self.emailField.accessibilityIdentifier = "emailField"
        self.passwordField.accessibilityIdentifier = "passwordField"
        self.registerButton.accessibilityIdentifier = "registerButton"
    }
    
    @objc override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsManager.shared.trackScreenView(screenName: "Registration")
    }
    
    @objc func didTapRegister() {
        
        AnalyticsManager.shared.trackEvent(category: "Registration Module", action: "Tapped", label: "Register Button")
        
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            self.displayAlert(title: "Registration", message: "Unable to register user")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in

            guard let _ = authResult?.user else {
                self?.displayAlert(title: "Registration", message: "Unable to register user")
                return
            }
            print("yay")
            self?.displayAlert(title: "Registration", message: "Success!", didTapOk: {
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}
