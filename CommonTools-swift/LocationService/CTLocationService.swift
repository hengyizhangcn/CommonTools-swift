//
//  CTLocationService.swift
//  Pods
//
//  Created by zhy on 9/11/16.
//
//

import CoreLocation

public class CTLocationService: NSObject, CLLocationManagerDelegate {
    public var locationResult: ((String?) -> Void)?
    public var locationAddress: String?
    
    private var locationManager:CLLocationManager?
    override public init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager.init()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 10

            if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 8.0 {
                locationManager?.requestAlwaysAuthorization()
            }
        } else {
            let alertView: UIAlertView = UIAlertView.init(title: "定位服务已关闭", message: "请到设置->隐私->定位服务中开启【U券】定位服务，以便您能搜索到最近的幸福券信息", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "设置")
            alertView.show()
        }
    }
    public static let instance = CTLocationService()
    public func startLocation() -> Void {
        locationManager?.startUpdatingLocation()
    }
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations.last!
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(currentLocation) { (array: [CLPlacemark]?, error: NSError?) in
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
                self.locationResult?(address)
                self.locationAddress = address
            }
        }
    }
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
//    if(error.code == kCLErrorLocationUnknown)
//    {
//    }
//    else if(error.code == kCLErrorNetwork)
//    {
//    }
//    else if(error.code == kCLErrorDenied)
//    {
//    [manager stopUpdatingLocation];
//    }
}
//
//#pragma mark - CoreLocation Delegate
//
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
//    CLLocation *currentLocation = [locations lastObject];
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
//    {
//    if (array.count > 0)
//    {
//    CLPlacemark *placemark = [array objectAtIndex:0];
//    //NSLog(@%@,placemark.name);//具体位置
//    //获取城市
//    NSString *city = placemark.locality;
//    if (!city) {
//    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//    city = placemark.administrativeArea;
//    }
//    cityName = city;
//    NSLog(@定位完成:%@,cityName);
//    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
//    }else if (error == nil && [array count] == 0)
//    {
//    NSLog(@No results were returned.);
//    }else if (error != nil)
//    {
//    NSLog(@An error occurred = %@, error);
//    }
//    }];
//}