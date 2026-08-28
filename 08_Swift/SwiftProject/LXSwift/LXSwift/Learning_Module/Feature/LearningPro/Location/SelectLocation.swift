//
//  SelectLocation.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/9/15.
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

class LocationViewController2: UIViewController {
    open var paramDic = [String: Any]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lock = NSLock()
    
    let geoCoder = CLGeocoder()
    
    // 记录地图是否完全加载
    var isMapViewFinished = false
    var isMapViewMoved = false
    
    var dataSource = [MapViewModel]()
    
    override func viewDidLoad() {
        title = "定位"
        view.backgroundColor = .white
        
        // 右侧按钮
        let rightItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(rightItemClick))
        navigationItem.rightBarButtonItem = rightItem
        
        // map view
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(self.mapView.snp.width)
        }
        
        mapView.addSubview(centerIMV)
        centerIMV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
            make.bottom.equalTo(self.mapView.snp.centerY)
        }
        
        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.mapView.snp.bottom)
        }
        
        /* {
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
        let coor_BD = CLLocationCoordinate2D(latitude: paramDic["y"] as! CLLocationDegrees, longitude: paramDic["x"] as! CLLocationDegrees)
        // 百度坐标 -> 高德坐标
        let coor_GCJ = ZJ_MapKits().transformFromBaiduToGCJ(p: coor_BD) as CLLocationCoordinate2D
        // 设置地图的中心点
        mapView.setCenter(coor_GCJ, animated: true)
        // 延迟执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 自定义缩放2-20
            let scale = self.paramDic["scale"] as! Int
            self.mapView.zoomLevel2 = Double(scale)
            // 获取数据源
            self.p_updateDataSource(latitude: coor_GCJ.latitude, longitude: coor_GCJ.longitude)
        }
    }
    
    deinit {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#line, #function)
        isMapViewMoved = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#line, #function)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#line, #function)
    }
    
    @objc func rightItemClick() {
        //
        print(#function)
    }
    
    func p_updateDataSource(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // tableview 不可点击
        tableView.isUserInteractionEnabled = false
        
        // 获取中心点 信息
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            if error != nil {
                self.view.makeToast("reverse geodcode fail: \(error!)")
                // tableview 恢复可点击
                self.tableView.isUserInteractionEnabled = true
                return
            }
            var placemark: CLPlacemark!
            let pms = placemarks! as [CLPlacemark]
            var addressString: String = ""
            if pms.count > 0 {
                placemark = pms[0] as CLPlacemark
//                if placemark.country != nil {
//                    addressString = addressString + placemark.country!
//                }
//                if placemark.administrativeArea != nil {
//                    addressString = addressString + placemark.administrativeArea! + ","
//                }
//                if placemark.locality != nil {
//                    addressString = addressString + placemark.locality! + ","
//                }
                if placemark.subLocality != nil {
                    addressString = addressString + placemark.subLocality! + ","
                }
                if placemark.thoroughfare != nil {
                    addressString = addressString + placemark.thoroughfare! + ","
                }
                if placemark.subThoroughfare != nil {
                    addressString = addressString + placemark.subThoroughfare! + ","
                }
                if placemark.name != nil {
                    addressString = addressString + placemark.name!
                }
            }
        
            // 组装数据，先清空，再添加
            self.dataSource.removeAll()
            //
            let centerModel = MapViewModel(title: "[当前位置]", subTitle: addressString, coordinate: self.mapView.centerCoordinate, isSelected: true)
            self.dataSource.append(centerModel)
            // 请求兴趣点
            self.requestPOI(coordinate: self.mapView.centerCoordinate)
        }
    }
    
    func requestPOI(coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1, longitudinalMeters: 1)
        request.region = region
        request.naturalLanguageQuery = "hotal"
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            if response == nil {
                return
            }
            let arr = response?.mapItems as! [MKMapItem]
            for item in arr {
                // 添加兴趣点数据
                var data = MapViewModel(title: item.placemark.name, subTitle: item.placemark.title, coordinate: item.placemark.coordinate, isSelected: false)
                self.dataSource.append(data)
            }
            // 刷新
            self.tableView.reloadData()
            // scroll to top
            let topRow = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
            
            // tableview 恢复可点击
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    var mapView: MKMapView = {
        let mapV = MKMapView()
        mapV.backgroundColor = .lightGray
        mapV.mapType = .standard
        mapV.showsUserLocation = false // 显示用户位置
        mapV.userTrackingMode = .none // 追踪模式
        mapV.showsTraffic = false // 显示交通状况
        mapV.showsScale = true // 显示比例尺
        mapV.showsCompass = true // 显示罗盘
        mapV.showsBuildings = true // 显示建筑物
        mapV.showsPointsOfInterest = true // 显示兴趣点
        return mapV
    }()
    
    var centerIMV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "location_tip")
        return imageV
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        // separator
        tv.separatorStyle = .singleLine
        tv.separatorColor = UIColor.orange
        // register
        tv.register(MapViewCell.self, forCellReuseIdentifier: "cell_identifier")
        return tv
    }()
}

extension LocationViewController2: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(#line, #function)
        print(userLocation)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if isMapViewFinished, isMapViewMoved {
            print(mapView.centerCoordinate)
            // 状态重置
            isMapViewMoved = false
            
            // 更新数据源
            p_updateDataSource(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print(mapView.centerCoordinate)
        isMapViewFinished = true
    }
}

extension MKMapView {
    // 2-20（其中2为世界地图）
    var zoomLevel2: Double {
        get {
            log2(360 * Double(frame.size.width) / 256.0 / region.span.longitudeDelta)
        }
        set {
            setCenterCoordinate2(coordinate: centerCoordinate, zoomLevel: newValue, animated: true)
        }
    }
    
    // 设置缩放级别时调用
    private func setCenterCoordinate2(coordinate: CLLocationCoordinate2D, zoomLevel: Double, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, zoomLevel) * Double(frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
}

extension LocationViewController2: UITableViewDataSource, UITableViewDelegate {
    /// Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // declare a tableViewCell as an implicitly unwrapped optional...
        var cell: MapViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell_identifier") as? MapViewCell

        // you CAN check this against nil, if nil then create a cell (don't redeclare like you were doing...
        if cell == nil {
            cell = MapViewCell(style: .default, reuseIdentifier: "cell_identifier")
        }
        
        cell!.model = dataSource[indexPath.row]
        
        return cell!
    }
    
    // MARK: ===== UITableViewDelegate

    /// didSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        for index in 0 ..< dataSource.count {
            dataSource[index].isSelected = false
        }
        
        let dd = dataSource[indexPath.row]
        
        dataSource[indexPath.row].isSelected = true
        
        tableView.reloadData()
        
        // 更新中心点
        mapView.setCenter(dataSource[indexPath.row].coordinate, animated: true)
    }
}

//
//
//
struct MapViewModel {
    var title: String?
    var subTitle: String?
    var coordinate: CLLocationCoordinate2D
    var isSelected: Bool
}

//
//
//
class MapViewCell: UITableViewCell {
    /// 存储属性
    private var _model: MapViewModel?
    
    /// 计算属性
    var model: MapViewModel? {
        set {
            _model = newValue
            // refresh
            titleLB.text = _model?.title
            subTitleLB.text = _model?.subTitle
            coordinateLB.text = "[\(_model?.coordinate.latitude ?? 0), \(_model?.coordinate.longitude ?? 0)]"
            selectedIMV.image = _model?.isSelected ?? false ? UIImage(named: "selected") : UIImage(named: "unselected")
        }
        get {
            return _model
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //
        p_createView()
    }
    
    func p_createView() {
        addSubview(titleLB)
        addSubview(subTitleLB)
        addSubview(coordinateLB)
        addSubview(selectedIMV)
        addSubview(sepLine)
        // layout
        let _margin = 20
        sepLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(_margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        selectedIMV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-_margin)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        titleLB.snp.makeConstraints { make in
            make.left.equalTo(self).offset(_margin)
            make.top.equalToSuperview()
            make.right.equalTo(self.selectedIMV.snp.left).offset(-_margin)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        subTitleLB.snp.makeConstraints { make in
            make.left.right.equalTo(self.titleLB)
            make.top.equalTo(self.titleLB.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        coordinateLB.snp.makeConstraints { make in
            make.left.right.equalTo(self.titleLB)
            make.top.equalTo(self.subTitleLB.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLB: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var subTitleLB: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var coordinateLB: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var selectedIMV: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "selected"))
        return imageV
    }()
    
    var sepLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
}
