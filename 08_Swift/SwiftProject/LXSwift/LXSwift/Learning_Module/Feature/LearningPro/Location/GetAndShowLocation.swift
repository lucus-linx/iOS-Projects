//
//  GetAndShowLocation.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/9/15.
//  Copyright © 2021 LX. All rights reserved.
//
//
//  获取定位并显示地图

import CoreLocation
import MapKit
import Toast_Swift
import UIKit

private class MyAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}

class GetShowLocationViewController: UIViewController {
        
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lock = NSLock()
    
    let geoCoder = CLGeocoder()
        
    override func viewDidLoad() {
        title = "定位"
        view.backgroundColor = .white
        
        //
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 定位精确度（最高）一般有电源接入，比较耗电
        locationManager.distanceFilter = kCLLocationAccuracyBest // 设备移动后获得定位的最小距离（适合用来采集运动的定位）
        // 定位请求
        requestLocationAccess()
        
        // bottom tip view
        view.addSubview(tipView)
        tipView.addSubview(tipIMV)
        tipView.addSubview(tipLabel)
        tipView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(bottomLayoutGuide.snp.bottom).offset(-80)
        }
        tipIMV.snp.makeConstraints { make in
            make.left.top.equalTo(self.tipView).offset(10)
            make.width.height.equalTo(30)
        }
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(self.tipIMV.snp.right).offset(10)
            make.top.right.equalTo(self.tipView)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        // map view
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.bottom.equalTo(self.tipView.snp.top)
        }
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
    
    var mapView: MKMapView = {
        let mapV = MKMapView()
        mapV.backgroundColor = .lightGray
        mapV.mapType = .standard
        mapV.showsUserLocation = false  // 显示用户位置
        mapV.userTrackingMode = .none   // 追踪模式
        mapV.showsTraffic = false       // 显示交通状况
        mapV.showsScale = true          // 显示比例尺
        mapV.showsCompass = true        // 显示罗盘
        mapV.showsBuildings = true      // 显示建筑物
        return mapV
    }()
    
    var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "12312231121fsfdadfdf"
        label.textColor = .green
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    var tipIMV: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "location_tip"))
        return imv
    }()
}

/*
 * 定位代理
 */
extension GetShowLocationViewController: CLLocationManagerDelegate {
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
        // WGS-84 -> GCJ-02
        let coor_GCJ = ZJ_MapKits().transformFromWGSToGCJ(wgsLoc: currentLocation!.coordinate) as CLLocationCoordinate2D
        // 设置地图的中心点
        mapView.setCenter(coor_GCJ, animated: true)
        // 显示跨度，1°约等于111KM
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        // 延迟执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 系统定位GWS-84，系统地图使用的是高德地图GCJ-02，所以需要将GWS-84 -> GCJ-02
            let center: CLLocationCoordinate2D = coor_GCJ
            self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
            // 添加自定义的大头针模型
            let annotation = MyAnnotation(title: "南京", subtitle: "石头桥", coordinate: center)
            self.mapView.addAnnotation(annotation)
        }
        
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
extension GetShowLocationViewController {
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
//                self.view.makeToast("reverse geodcode success: \(addressString)")
                self.tipLabel.text = addressString
            }
        }
    }
}

extension GetShowLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let identifier = "annotationView_ID"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.animatesDrop = true
                // 设置大头针颜色
                annotationView?.pinTintColor = .red
                // 设置大头针点击注释的右侧按钮样式
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(#line, #function)
    }
}

