//
//  ViewController.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var arrDrawMarker: [GMSMarker] = []
    var infoWindow: CustomInfoWindowView = CustomInfoWindowView()
    var tappedmarker = GMSMarker()
    var arrayCamera:[Camera] = []
    let viewModel = TrafficViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        UserLocationManger.shared.startUpdatingLocation()
        self.prepareUI()
        // Do any additional setup after loading the view.
    }
    
}

extension ViewController{
    func prepareUI(){
        delay(0.2) {
            self.setUpMap()
        }
        self.prepareViewModelObserver()
    }
    func setUpMap(){
           let camera = GMSCameraPosition.camera(withLatitude: UserLocationManger.shared.cLatitude,
                                                 longitude:UserLocationManger.shared.cLongitude, zoom:12.0)
           mapView.camera = camera;
           mapView.isMyLocationEnabled = true
           mapView.delegate = self
           mapView.preferredFrameRate = .powerSave
           self.fetchTrafficImageData()
    }
}

// MARK: - Get Live Traffic camera info
extension ViewController{
    func fetchTrafficImageData() {
        let strDate = Date().dateToString()
        viewModel.getTrafficImageDataApi(strDate: strDate)
    }
    
    func prepareViewModelObserver() {
           self.viewModel.getTrafficImageData = { (error, response) in
               if(error != nil){
                   self.showAlert(title: APPName, message: error?.localizedDescription)
                   return
               }
                self.showTrafficCamera(arrayCamera: self.viewModel.trafficeInfoDM!.items[0].cameras)
           }
       }
    
    func showTrafficCamera(arrayCamera:[Camera]){
        self.arrayCamera = arrayCamera
        for i in 0..<arrayCamera.count{
            let camera:Camera = arrayCamera[i]
            let marker = GMSMarker()
            let locValue:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(camera.location.latitude), Double(camera.location.longitude))
            marker.position = locValue
            marker.accessibilityLabel = "\(camera.cameraID)"
            marker.map = mapView
            mapView.selectedMarker = marker
            arrDrawMarker.append(marker)
        }
    }
}


// MARK: - GMSMapViewDelegates
extension ViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if self.view.subviews.contains(self.infoWindow) {
            self.infoWindow.removeFromSuperview()
        }
        self.tappedmarker = marker
        var point = mapView.projection.point(for: marker.position)
        point.y = point.y - 90
        let camera = mapView.projection.coordinate(for: point)
        let position = GMSCameraUpdate.setTarget(camera)
        mapView.animate(with: position)
        self.infoWindow = Bundle.main.loadNibNamed("CustomInfoWindowView", owner: self, options: nil)?.first as! CustomInfoWindowView
        self.infoWindow.center = mapView.projection.point(for: marker.position)
        self.infoWindow.center.y = self.infoWindow.center.y - 90
      
        var strUrl : String = ""
        if self.arrayCamera.contains(where: {$0.cameraID == marker.accessibilityLabel}){
            let index = self.arrayCamera.firstIndex(where: {$0.cameraID == marker.accessibilityLabel})
            strUrl = self.arrayCamera[index!].image
            self.infoWindow.imgCamera.load(url: URL(string: strUrl)!)
        }
        self.view.addSubview(self.infoWindow)
        self.infoWindow.bringSubviewToFront(self.view)
        return true
    }
   
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.infoWindow.center = mapView.projection.point(for: tappedmarker.position)
        self.infoWindow.center.y = self.infoWindow.center.y - 90
    }

}
