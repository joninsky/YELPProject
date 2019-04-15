//
//  UIView_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit


extension UIView {
    /// Function to quickly constrain a view four sides to its superview
    ///
    /// - Parameters:
    ///   - insets: The edge insets for every side
    ///   - useSafeArea: Do you wan to constrain to the superviews safearea?
    public func constrainToSuperview(_ insets: UIEdgeInsets, useSafeArea: Bool = true) {
        guard let superView = self.superview else {
            return
        }
        
        if useSafeArea {
            if #available(iOS 11, *) {
                self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
                self.rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor, constant: insets.right).isActive = true
                self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom).isActive = true
                self.leftAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leftAnchor, constant: insets.left).isActive = true
                return
            }
        }
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: insets.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: insets.bottom).isActive = true
        self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: insets.left).isActive = true
    }
}
