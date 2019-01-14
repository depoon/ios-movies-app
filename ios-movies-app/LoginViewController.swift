//
//  LoginViewController.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 27/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    static func initFromStoryboard() -> LoginViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.didTapClose))
        self.registerButton.addTarget(self, action: #selector(self.didTapRegister), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(self.didTapLogin), for: .touchUpInside)
        self.emailField.accessibilityIdentifier = "emailField"
        self.passwordField.accessibilityIdentifier = "passwordField"
        self.registerButton.accessibilityIdentifier = "registerButton"
        self.loginButton.accessibilityIdentifier = "loginButton"

    }
    
    @objc override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsManager.shared.trackScreenView(screenName: "Login")
    }
    
    @objc func didTapClose() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapRegister() {
        AnalyticsManager.shared.trackEvent(category: "Login Module", action: "Tapped", label: "Register Button")
        
        let vc = RegistrationViewController.initFromStoryboard()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapLogin() {
        
        AnalyticsManager.shared.trackEvent(category: "Login Module", action: "Tapped", label: "Login Button")
        
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            self.displayAlert(title: "Login", message: "Unable to login")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let _ = user else {
                self?.displayAlert(title: "Login", message: "Unable to login")
                return
            }
            self?.displayAlert(title: "Login", message: "Login Success", didTapOk: {
                self?.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
}
