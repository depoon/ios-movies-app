//
//  UIViewController+DisplayAlert.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 28/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String, didTapOk: (()-> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            didTapOk?()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
