//
//  AppDelegate.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleAPIKey)
        UserLocationManger.shared.getCurrentLocation()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func openAppSetting(){

          if !CLLocationManager.locationServicesEnabled() {
              //App-Prefs:root=LOCATION_SERVICES
              if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION"){
                  // If general location settings are disabled then open general location settings
                  if #available(iOS 10.0, *){
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  }else{
                      UIApplication.shared.openURL(url)
                  }
                  
              }
              
          } else {
              if let url = URL(string: UIApplication.openSettingsURLString) {
                  // If general location settings are enabled then open location settings for the app
                  if #available(iOS 10.0, *){
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  }else{
                      UIApplication.shared.openURL(url)
                  }
              }
          }
      }

}

extension UIApplicationDelegate {
    
    static var shared: Self {
        return UIApplication.shared.delegate! as! Self
    }
}
