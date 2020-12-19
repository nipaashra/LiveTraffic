
//
//  NATrafficInfoApi.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import UIKit
import GoogleMaps
import CoreLocation

enum LocationService: Int {
    case never
    case whenInUser
    case always
}

enum LocationPermission: Int {
    case accepted
    case denied
    case error
}

enum LocationType: Int {
    case background
    case significant
    case `default`
}

class UserLocationManger: NSObject,CLLocationManagerDelegate {
    static let shared =  UserLocationManger()
    var cLatitude:Double = 1.29027
    var cLongitude:Double = 103.851959
    var isUpdateStartLocation: Bool = false
    var locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    var locationService: LocationService = .whenInUser

}

extension UserLocationManger{
    ///////////////////////////////////////
    // MARK: Location Method
    ///////////////////////////////////////
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
        //        let obj = self.tokenGeneratedMethod()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locValue = manager.location!.coordinate
        self.cLatitude = manager.location!.coordinate.latitude
        self.cLongitude = manager.location!.coordinate.longitude
    }

    func getAddress(lat:Double, long:Double) -> String{
        var add:String = ""
        self.getPlaceName(lat: lat, long: long) { (address) in
            add = address
        }
        return add
    }
    
    func getPlaceName(lat:Double, long:Double,completionHandler: @escaping (_ add: String) -> Void)
    {
        let location = CLLocation(latitude: lat, longitude: long)
        let geoCoder : CLGeocoder! = CLGeocoder()
        var add = ""
        geoCoder.reverseGeocodeLocation(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil && (placemarks?.count)! > 0
            {
                let pm = placemarks?.last
                var addressString : String = ""
                if pm?.subLocality != nil {
                    addressString = addressString + (pm?.subLocality!)! + ", "
                }
                if pm?.thoroughfare != nil {
                    addressString = addressString + (pm?.thoroughfare!)! + ", "
                }
                if pm?.locality != nil {
                    addressString = addressString + (pm?.locality!)! + ", "
                }
                if pm?.country != nil {
                    addressString = addressString + (pm?.country!)! + ", "
                }
                if pm?.postalCode != nil {
                    addressString = addressString + (pm?.postalCode!)! + " "
                }
                add = addressString
                print(add)
                completionHandler(add)
            }
        }
    }
    func requestForPermission(){
        if locationService == .always{
            self.locationManager.requestAlwaysAuthorization()
        }else if locationService == .whenInUser{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkAuthorizationStatus(vc:UIViewController?) -> Bool {
        let status = CLLocationManager.authorizationStatus()
        // If status is denied or only granted for WhenInUse/Always
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            if UIApplication.shared.applicationState == .active{
                let alertController = UIAlertController(title: locationAccessTitle, message: locationAccessMsg, preferredStyle: UIAlertController.Style.alert)
                let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    AppDelegate.shared.openAppSetting()
                }
                alertController.addAction(okAction)
                if vc != nil{
                    vc?.present(alertController, animated: true, completion: nil)
                }
            }
            return false
        } else if status == CLAuthorizationStatus.notDetermined {
            self.requestForPermission()
            return false
        } else if status == CLAuthorizationStatus.authorizedAlways {
            if locationService == .whenInUser{
                self.requestForPermission()
                self.locationManager.startUpdatingLocation()
                return true
            }
            return true
        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
            if locationService == .always{
                self.requestForPermission()
                self.locationManager.startUpdatingLocation()
                return true
            }
            return true
        }
        return false
    }
    
}
