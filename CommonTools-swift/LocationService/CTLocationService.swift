//
//  CTLocationService.swift
//  Pods
//
//  Created by zhy on 9/11/16.
//
//

import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class CTLocationService: NSObject, CLLocationManagerDelegate {
    open var locationResult: ((String?) -> Void)?
    open var locationAddress: String?
    open var placemark: CLPlacemark?
    
    let locationManager = CLLocationManager()
    override public init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10

            if NSString(string: UIDevice.current.systemVersion).floatValue >= 8.0 {
                locationManager.requestAlwaysAuthorization()
            }
        } else {
            let alertView: UIAlertView = UIAlertView.init(title: "定位服务已关闭", message: "请到设置->隐私->定位服务中开启定位服务", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "设置")
            alertView.show()
        }
    }
    open static let instance = CTLocationService()
    open func startLocation() -> Void {
        locationManager.startUpdatingLocation()
    }
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations.last!
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(currentLocation) { (array: [CLPlacemark]?, error: Error?) in
            if array?.count > 0 {
                let placemark: CLPlacemark = (array?.first)!
                var city: String? = placemark.locality
                if city == nil {
                    city = placemark.administrativeArea
                }
                
                let administrativeArea: String = placemark.administrativeArea != nil ? placemark.administrativeArea! :
                    (placemark.subAdministrativeArea != nil ? placemark.subAdministrativeArea! : "")
                let locality: String = placemark.locality != nil ? placemark.locality! : ""
                let subLocality: String = placemark.subLocality != nil ? placemark.subLocality! : ""
                let name: String = placemark.name != nil ? placemark.name! : ""
                let address: String = administrativeArea + " " + locality + " " + subLocality + " " + name
                manager.stopUpdatingLocation()
                self.locationAddress = address
                self.placemark = placemark
                self.locationResult?(address)
            }
        }
    }
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
