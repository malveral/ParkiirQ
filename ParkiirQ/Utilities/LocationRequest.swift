//
//  LocationManager.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//
import CoreLocation

class LocationRequest: NSObject, CLLocationManagerDelegate {
    
    //MARK: Object to Access Location Services
    private let locationManager = CLLocationManager()
    
    //MARK: Set up the Location Manager Delegate
    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    // Request authorization async
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: Is authorized
    var isAuthorized: Bool {
        return locationManager.authorizationStatus == .authorizedWhenInUse
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorized = manager.authorizationStatus == .authorizedWhenInUse
        NotificationCenter
            .default
            .post(name: .isLocationAuthorized, object: authorized)
    }
    
}
