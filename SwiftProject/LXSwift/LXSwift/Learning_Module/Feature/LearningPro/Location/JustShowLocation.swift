//
//  Location.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/9/14.
//  Copyright © 2021 LX. All rights reserved.
//

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

class LocationViewController: UIViewController {
    
    open var paramDic = [String : Any]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lock = NSLock()
    
    let geoCoder = CLGeocoder()
        
    override func viewDidLoad() {
        title = "定位"
        view.backgroundColor = .white
        
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
        
        /*{
             x = "118.802045";
             address = "";
             scale = 28;
             y = "32.067192";
             mark = "江苏省南京市玄武区鸡鸣寺路1号";
             type = "wgs84";
             spaceId = "APICeShiQiYe";
         }
         // 纬度，浮点数，范围为90 ~ -90
         // 经度，浮点数，范围为180 ~ -180
         */
        self.tipLabel.text = paramDic["mark"] as? String
        let coor_BD = CLLocationCoordinate2D(latitude: paramDic["y"] as! CLLocationDegrees, longitude: paramDic["x"] as! CLLocationDegrees)
        // 百度坐标 -> 高德坐标
        let coor_GCJ = ZJ_MapKits().transformFromBaiduToGCJ(p: coor_BD) as CLLocationCoordinate2D
        // 设置地图的中心点
        mapView.setCenter(coor_GCJ, animated: true)
        // 延迟执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 自定义缩放2-20
            let scale = self.paramDic["scale"] as! Int
            self.mapView.zoomLevel = Double(scale) 
            // 添加自定义的大头针模型
            let annotation = MyAnnotation(title: "南京", subtitle: "石头桥", coordinate: coor_GCJ)
            self.mapView.addAnnotation(annotation)
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
        mapV.showsUserLocation = true   // 显示用户位置
        mapV.userTrackingMode = .follow // 追踪模式
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

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let identifier = "annotationView_ID"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                /* 自定义
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(named: "location_tip")
                 */
                // MKPinAnnotationView 系统样式
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true   // 显示大头针小标题
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

extension MKMapView {
    // 2-20（其中2为世界地图）
    var zoomLevel: Double {
        get {
            log2(360 * Double(frame.size.width) / 256.0 / region.span.longitudeDelta)
        }
        set {
            setCenterCoordinate(coordinate: centerCoordinate, zoomLevel: newValue, animated: true)
        }
    }
    
    // 设置缩放级别时调用
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Double, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, zoomLevel) * Double(frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
}
