//
//  GetLocation.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/9/15.
//  Copyright © 2021 LX. All rights reserved.
//
//
//  仅仅获取当前定位

import CoreLocation
import Toast_Swift
import UIKit

class GetLocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lock = NSLock()
    
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        title = "获取定位"
        view.backgroundColor = .white
        
        //
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 定位精确度（最高）一般有电源接入，比较耗电
        locationManager.distanceFilter = kCLLocationAccuracyBest // 设备移动后获得定位的最小距离（适合用来采集运动的定位）
        // 定位请求
        requestLocationAccess()
    }

    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            QYYToast.showToast(withMessage: "请前往开启定位权限", type: .error)
        default:
            locationManager.requestWhenInUseAuthorization() // 弹出用户授权对话框，使用程序期间授权（iOS 8后)
        }
    }
    
    deinit {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#line, #function)
    }
}

/*
 * 定位代理
 */
extension GetLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
                // 开始定位
                locationManager.startUpdatingLocation()
            }
        } else {
            // Fallback on earlier versions
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                // 开始定位
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print(#line, #function)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print(#line, #function)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lock.lock()
        currentLocation = locations.last // 注意：获取集合中最后一个位置（最新的位置）
        let high = String(describing: currentLocation?.altitude)
        let jing = String(describing: currentLocation?.coordinate.longitude)
        let wei = String(describing: currentLocation?.coordinate.latitude)
        print("高度：\(high)")
        print("定位经纬度为：\(jing) : \(wei)")
        QYYToast.showToast(withMessage: "定位经纬度为：\(jing) : \(wei)", type: .success)        
        if currentLocation != nil {
            LocationToCity()
        } else {
            print("定位失败！！！")
        }
        // 停止定位
        locationManager.stopUpdatingLocation()
        lock.unlock()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错拉！！\(error)")
            
        view.makeToast("定位出错拉！！\(error)")
    }
}

/*
 * Map
 */
extension GetLocationViewController {
    func LocationToCity() {
        geoCoder.reverseGeocodeLocation(currentLocation!) { placemarks, error in
            if error != nil {
                self.view.makeToast("reverse geodcode fail: \(error!)")
                return
            }
            var placemark: CLPlacemark!
            let pms = placemarks! as [CLPlacemark]
            if pms.count > 0 {
                placemark = pms[0] as CLPlacemark
                var addressString: String = ""
                if placemark.subThoroughfare != nil {
                    addressString = placemark.subThoroughfare! + " "
                }
                if placemark.thoroughfare != nil {
                    addressString = addressString + placemark.thoroughfare! + ", "
                }
                if placemark.postalCode != nil {
                    addressString = addressString + placemark.postalCode! + " "
                }
                if placemark.locality != nil {
                    addressString = addressString + placemark.locality! + ", "
                }
                if placemark.administrativeArea != nil {
                    addressString = addressString + placemark.administrativeArea! + " "
                }
                if placemark.country != nil {
                    addressString = addressString + placemark.country!
                }
                self.view.makeToast("reverse geodcode success: \(addressString)")
            }
        }
    }
}
