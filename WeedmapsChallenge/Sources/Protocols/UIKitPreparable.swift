//
//  UIKitCodePreparable.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


/// I like to do a lot of stuff in code. This protocol signals that I'm going to take care of things outside of storyboards
protocol UIKitCodePreparable {
    /// Function that will set up UIKit elements that are part of the view. It should also put together the `UIView` Heirarchy
    func prepare()
    /// Function that is meant to handle the constraining of all elements in the conforming class.
    func constrain()
}
