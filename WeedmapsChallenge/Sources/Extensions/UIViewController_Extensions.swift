//
//  UIViewController_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit


extension UIViewController {
    
    
    typealias UIAlertOKPressed = (_ action: UIAlertAction) -> Void
    typealias UIAlertPresented = () -> Void
    
    
    /// Real simple for now. If we need to display an error we display the localized description in an alert view.
    ///
    /// - Parameter error: The `Error` object
    ///   - okPressed: User dismiss completion
    ///   - presented: ALert presented completion.
    internal func alert(forError error: Error, okPressed: UIAlertOKPressed? = nil, presented: UIAlertPresented? = nil) {
        let alert = UIAlertController(title: "Something went wrong", message: "This is what the error says:\n\n\(error.localizedDescription)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: okPressed)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: presented)
    }
    
    /// Just a little more convenience for me. Don't have to worry about callbacks if I don't want.
    ///
    /// - Parameters:
    ///   - title: The bold text in the alert
    ///   - message: The non bold text in the alert
    ///   - okPressed: User dismiss completion
    ///   - presented: ALert presented completion.
    internal func alert(title: String?, message: String?, okPressed: UIAlertOKPressed? = nil, presented: UIAlertPresented? = nil) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: okPressed)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: presented)
    }
}
