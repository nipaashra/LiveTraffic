//
//  NATrafficInfoApi.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

typealias APICompletionHandler = (_ error:Error?, _ responseJson: TrafficInfo?) -> Void

class NATrafficInfoApi {
   static func getTrafficImageData(dateTime:String, completionHandler:@escaping APICompletionHandler){
        let strUrl = baseUrl + "transport/traffic-images?date_time=\(dateTime)"
        let url = URL(string: strUrl)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                     do {
                        let trafficInfoDM = try JSONDecoder().decode(TrafficInfo.self, from: data)
                        completionHandler(nil, trafficInfoDM)
                     } catch let error {
                        print(error)
                        completionHandler(error, nil)
                     }
                }
        }
        task.resume()
    }
}


