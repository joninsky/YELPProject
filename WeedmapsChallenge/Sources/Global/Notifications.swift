//
//  Notifications.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation



public let StartLocationSessionNotification = Notification.Name.init("StartLocationSessionNotification")
/// Notification that gets fired when the user ends a location session
public let EndLocationSessionNotification = Notification.Name.init("EndLocationSessionNotification")
/// Notification that gets fired when location service authorization delegate gets called back. Passed the `CLAuthorizationStatus` through in the `.object` property of this notification.
public let LocationServicesChangedNotification = Notification.Name.init("LocationServicesChangedNotification")
/// Notification that gets fired when there is a new location. Will pass the `CLLocation` through in the `.object` property of this notification.
public let NewLocationNotification = Notification.Name.init("NewLocationNotification")
/// There was an error in the location services from iOS. Will pass the `Error` through in the `.object` property of this notification.
public let LocationServiceErrorNotification = Notification.Name.init("LocationServiceErrorNotification")
