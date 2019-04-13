//
//  LocationController.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//
import CoreLocation

//https://developer.apple.com/documentation/corelocation/getting_the_user_s_location/handling_location_events_in_the_background
//https://developer.apple.com/documentation/uikit/uiapplication/launchoptionskey/1623101-location

public class LocationController: NSObject {
    //MARK: Public Properties
    /// Retreives the cached location from the location manager if one is available.
    public var location: CLLocation? {
        return self.manager.location
    }
    /// Are location services currently running? Was `.startUpdatingLocation()` ever called with no matching `.stopUpdatingLocation()`
    public var isRunning: Bool = false
    /// Typealias for the async get location function completion.
    public typealias GetLocationCompletion = ((_ location: CLLocation) -> Void)
    //MARK: Private Properties
    private let manager = CLLocationManager()
    
    var getLocationCompletion: GetLocationCompletion?
    
    
    
    
    //MARK: Init
    /// Initalizer for the `LocationController`
    override public init() {
        super.init()
        self.prepare()
    }
    
    //MARK: Public Functions
    /// Retrieves the `LocationServiceStatus` of iOS
    ///
    /// - Returns: A `LocationServiceStatus` enumeration
    public func locationServiceStatus() -> LocationServiceStatus {
        if CLLocationManager.locationServicesEnabled() {
            return LocationServiceStatus.on
        }else {
            return LocationServiceStatus.off
        }
    }
    
    /// Returns the `CLAuthorizationStatus` for the app
    ///
    /// - Returns: A `CLAuthorizationStatus` enumeration
    public func locationServiceAuthorizationLevel() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    /// Call this function to start location services. If the user has not authorized the application this will also request to authorize the application. After this the `.isRunning` property should be set to true. Location services should be returning a location and the app should be set up for monitoring significant location changes. Finally the `StartLocationSessionNotification` will be fired.
    public func startLocationServices() {
        self.isRunning = true
        self.manager.startUpdatingLocation()
        self.manager.startMonitoringSignificantLocationChanges()
        NotificationCenter.default.post(name: StartLocationSessionNotification, object: nil)
        self.manager.requestLocation()
    }
    
    /// Call this function to stop location services. After this the `.isRunning` property will be set to false. The location manager will be shut down and the app will stop monitoring for significant location changes. Finally the `EndLocationSessionNotification` will be called.
    public func stopLocationServices() {
        self.isRunning = false
        self.manager.stopUpdatingLocation()
        self.manager.stopMonitoringSignificantLocationChanges()
        NotificationCenter.default.post(name: EndLocationSessionNotification, object: nil)
    }
    
    /// Call this function to request location authorization for your app.
    public func requestAuthorization() {
        self.manager.requestWhenInUseAuthorization()
    }
    
    
    /// Function that will ask the location manager to get a fresh location. When a fresh location is received via the location manager delegate the completion will get called with that fresh location.
    ///
    /// - Parameter completion: The completion that will return you the fresh location.
    public func location(completion: @escaping(GetLocationCompletion)) {
        self.getLocationCompletion = completion
        self.manager.requestLocation()
    }
    
    //MARK: Private functions
    
    
    //MARK: De - Init
    deinit {
        print("De - Init LocationController")
    }
    
}

extension LocationController: CLLocationManagerDelegate {
    ///:nodoc:
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: LocationServicesChangedNotification, object: status)
    }
    
    ///:nodoc:
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        self.getLocationCompletion?(location)
        
        self.getLocationCompletion = nil
        
        NotificationCenter.default.post(name: NewLocationNotification, object: location)
    }
    
    ///:nodoc:
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NotificationCenter.default.post(name: LocationServiceErrorNotification, object: error)
    }
    
}

extension LocationController {
    func prepare(){
        //Set up locaiton manager
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.manager.distanceFilter = 40
        //kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyBest
        self.manager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 11.0, *) {
            self.manager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
    }
}

