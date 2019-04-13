//
//  LocationControllerAvailable.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit


protocol LocationControllerAvailable {
    var locationController: LocationController? { get }
}


extension LocationControllerAvailable {
    var locationController: LocationController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.locationController
    }
}
