//
//  Extension.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow{
    
    func showIndicatior(){
        self.dissmissIndicator()
        let indicatorView = UIView.init(frame: self.frame)
        indicatorView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        indicatorView.tag = baseTag.iIndicatorView
        indicatorView.center = self.center
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor.white
        indicator.center = indicatorView.center
        
        indicatorView.addSubview(indicator)
        indicator.startAnimating()
        self.addSubview(indicatorView)
    }
    
    func dissmissIndicator(){
        
        if let vwIndicator = viewWithTag(baseTag.iIndicatorView){
            vwIndicator.removeFromSuperview()
        }
    }
    
}

extension UIViewController {
    @discardableResult public func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    
}
func delay(_ delay:Double, closure:@escaping ()->()) {
     DispatchQueue.main.asyncAfter(
         deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
 }

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Date {
    public func dateToString() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let myString = formatter.string(from: Date()) 
        return myString
    }
    
    public func mockDateToString() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd'HH:mm"
        let myString = formatter.string(from: Date())
        return myString
    }
}
