//
//  TrafficViewModel.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

protocol TrafficViewModelProtocol {
    
    var getTrafficImageData: ((_ error:Error?, _ responseJson: TrafficInfo?) -> Void)? { get set }
    func getTrafficImageDataApi(strDate:String)
}

class TrafficViewModel: TrafficViewModelProtocol {
    
    var getTrafficImageData: ((Error?, TrafficInfo?) -> Void)?
    
    var trafficeInfoDM: TrafficInfo? {
        didSet {
            self.getTrafficImageData!(nil, self.trafficeInfoDM)
        }
    }
    func getTrafficImageDataApi(strDate:String){
         NATrafficInfoApi.getTrafficImageData(dateTime: strDate) { (error, response) in
            DispatchQueue.main.async {
                if(error != nil){
                    self.getTrafficImageData!(error, nil)
                }else{
                    self.trafficeInfoDM = response
                }
                
            }
            
        }
    }
   
    
}
