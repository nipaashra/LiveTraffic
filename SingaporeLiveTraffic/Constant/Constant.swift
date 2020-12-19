//
//  Constant.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

let baseUrl = "https://api.data.gov.sg/v1/"
let APPName = "Live Traffic"
let googleAPIKey = "AIzaSyBC94LZ9ksYoyP8vDmfN5vgUOFoUcRDPkI"
let locationAccessMsg = "Please turn on location services for \(APPName) from location settings. So application can able to fetch data."
let locationAccessTitle = "Location services are off"

struct baseTag{
    static let iIndicatorView = 1000
}


struct responseKeys {
    static let successCode = 200
}

struct  generalMessages {
    static let errorMsg = "Sorry, something went wrong with the server, please try again."//"Something went wrong. Please try again!"
}
