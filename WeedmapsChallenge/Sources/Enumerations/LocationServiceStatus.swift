//
//  LocationServiceStatus.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


/// This represents the status of the location services of the device. Since the authorization status has a nice enumeration I figured why not give the overall location service status a nice a enumeration also? This is that enumeration.
///
/// - on: Are location services turned on?
/// - off: Are location services turned off?
public enum LocationServiceStatus: String {
    case on = "On"
    case off = "Off"
}
