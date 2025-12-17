//
//  ViewController.swift
//  C254MapDemo
//
//  Created by Danny Shen on 2025/11/25.
//
//

import UIKit
import MapKit

struct LandMark{
    var location:CLLocationCoordinate2D
    var title:String
    var city:String
}

class ViewController: UIViewController {

    var landmarkFlag = 0
    let landmarks: [LandMark] = [
        // 東京 Tokyo
        LandMark(location: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
                  title: "東京鐵塔",
                  city: "東京"),
        LandMark(location: CLLocationCoordinate2D(latitude: 35.7100, longitude: 139.8107),
                  title: "東京晴空塔",
                  city: "東京"),
        LandMark(location: CLLocationCoordinate2D(latitude: 35.6852, longitude: 139.7528),
                  title: "皇居",
                  city: "東京"),

        // 舊金山 San Francisco
        LandMark(location: CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.4783),
                  title: "金門大橋",
                  city: "舊金山"),
        LandMark(location: CLLocationCoordinate2D(latitude: 37.8021, longitude: -122.4187),
                  title: "科伊特塔",
                  city: "舊金山"),
        LandMark(location: CLLocationCoordinate2D(latitude: 37.7694, longitude: -122.4862),
                  title: "金門公園",
                  city: "舊金山"),

        // 巴黎 Paris
        LandMark(location: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
                  title: "艾菲爾鐵塔",
                  city: "巴黎"),
        LandMark(location: CLLocationCoordinate2D(latitude: 48.8606, longitude: 2.3376),
                  title: "羅浮宮",
                  city: "巴黎"),
        LandMark(location: CLLocationCoordinate2D(latitude: 48.8738, longitude: 2.2950),
                  title: "凱旋門",
                  city: "巴黎"),

        // 倫敦 London
        LandMark(location: CLLocationCoordinate2D(latitude: 51.5007, longitude: -0.1246),
                  title: "大笨鐘",
                  city: "倫敦"),
        LandMark(location: CLLocationCoordinate2D(latitude: 51.5033, longitude: -0.1196),
                  title: "倫敦眼",
                  city: "倫敦"),
        LandMark(location: CLLocationCoordinate2D(latitude: 51.5055, longitude: -0.0754),
                  title: "塔橋",
                  city: "倫敦")
    ]
    
    let taipeiStation = LandMark(location: CLLocationCoordinate2D(latitude: 25.04869, longitude: 121.51417),
                                 title: "台北車站",
                                 city: "台北")
    
    
    
    private var timer: Timer?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var camHeightSlideer: UISlider!
    @IBOutlet weak var rotationSwitch: UISwitch!
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var landmarkSelectButton: UIButton!
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager.requestWhenInUseAuthorization() //要求授權使用者位置

        locationManager.delegate = self //指定代理人
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //指定精準度
        locationManager.activityType = .automotiveNavigation //追蹤的種類，可指定為車輛，行人，跑步，飛行等模式
        locationManager.startUpdatingLocation()   //開始追蹤
//        mapView.userTrackingMode = .followWithHeading  使用者追蹤模式，會自動開啟使用者位置，預設 .none 顯示時有方向與無方向等兩種
        mapView.showsUserLocation = true //顯示使用者位置
       

        
        
        //設定地標資料
        landmarkSelectButton.showsMenuAsPrimaryAction = true
        var menuItme:[UIMenuElement] = []
        landmarks.forEach { item in
            menuItme.append(UIAction(title:"\(item.city):\(item.title)",handler: { action in
                self.showLandMark(landMark: item)
            }))
        }
        let menu = UIMenu(title:"請選擇地點",children: menuItme)
        landmarkSelectButton.menu = menu
        
        
        
        
        // Demo Annotation
//        var latitude:CLLocationDegrees = 25.0469147
//        var longitude:CLLocationDegrees = 121.5102663
//        
////        for i in 0..<10{
////            latitude += Double(i) * 0.0001
//            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = "台北車站" //  \(i)"
//            annotation.subtitle = "subTitle"
//            mapView.addAnnotation(annotation)
////        }


//        //Demo MKCircle
//        mapView.delegate = self
//        let annotationCircle = MKCircle(center: taipeiStation.location, radius: 500)
//        annotationCircle.title = "台北車站"
//        annotationCircle.subtitle = "subTitle"
//        mapView.addOverlay(annotationCircle)
//        mapView.addAnnotation(annotationCircle)
        
        


        
        //設定第一個追蹤點
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.nextLandmark(self)
//        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            if let coordinate = self.locationManager.location?.coordinate{
//                let xScale:CLLocationDegrees = 0.01
//                let yScale:CLLocationDegrees = 0.01
//                let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: xScale, longitudeDelta: yScale)
//                let region =  MKCoordinateRegion(center: coordinate, span: span)
//                self.mapView.setRegion(region, animated: true)
//            }
//
//
////            //設定基本範圍
////
////            let latitude:CLLocationDegrees = 25.0469147
////            let longitude:CLLocationDegrees = 121.5102663
////            let location:CLLocationCoordinate2D =
////            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
////            let xScale:CLLocationDegrees = 0.01
////            let yScale:CLLocationDegrees = 0.01
////            let span:MKCoordinateSpan =
////            MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta: xScale)
////
////            let region:MKCoordinateRegion =
////            MKCoordinateRegion.init(center: location, span: span)
////            self.mapView.setRegion(region, animated: true)
////
////

        
        //顯示子元件
        //iOS 11 之後，指南針與比例尺是動態的, 如果要持續顯示，要自已加上
        //        mapView.showsCompass = true
        //        mapView.showsScale = true
        //        mapView.showsUserTrackingButton = true
        

        //指北針
        mapView.showsCompass = false //避免重覆顯示
        let compass = MKCompassButton(mapView: mapView) //取得元件 View
        compass.compassVisibility = .visible // 持續顯示，也可設 .adaptive:動態 .hidden:不顯示
        mapView.addSubview(compass)
        // 設定位置 (右上角)
        compass.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compass.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
            compass.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10)
        ])
        
        // 使用者追蹤按鈕
        mapView.showsUserTrackingButton = false
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(trackingButton)
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        //指北針的下面
        NSLayoutConstraint.activate([
            trackingButton.topAnchor.constraint(equalTo: compass.bottomAnchor, constant: 10),
            trackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10)
        ])
        
        // 比例尺
        mapView.showsScale = false
        let scale = MKScaleView(mapView: mapView)
        scale.scaleVisibility = .visible
        mapView.addSubview(scale)
        // 設定位置 (右下角)
        scale.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scale.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10),
            scale.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10)
        ])
    }
    
    @IBAction func setMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        case 3:
            mapView.mapType = .satelliteFlyover
        case 4:
            mapView.mapType = .hybridFlyover
        case 5:
            mapView.mapType = .mutedStandard
        default:
            break
        }
    }
    
    @IBAction func goTaipeiStation(_ sender: Any) {
        showLandMark(landMark: taipeiStation)
    }
    
    
    @IBAction func changHeight(_ sender: UISlider) {
        let currentCamera = mapView.camera
        currentCamera.altitude = Double(camHeightSlideer.value)          // 攝影機高度，數值越大縮放越小
        mapView.setCamera(currentCamera, animated: true)
    }
    
    
    
    func showLandMark(landMark:LandMark){
        
        // 建立相機
        let camera = mapView.camera
        camera.centerCoordinate = landMark.location
        camera.pitch = 45                // 攝影機俯角，可調整 0~80
        camera.heading = 0              // 地圖朝向角度
        camera.altitude = Double(camHeightSlideer.value)          // 攝影機高度，數值越大縮放越小
        
        // 移動到新位置
        mapView.setCamera(camera, animated: true)

        //加上大頭針
        mapView.removeAnnotations(mapView.annotations) // 先清空
        let annotation = MKPointAnnotation()
        annotation.coordinate = landMark.location
        annotation.title = landMark.title
        annotation.subtitle = landMark.city
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func rotation(_ sender: UISwitch) {
        if sender.isOn{
            startSlowRotation()
        }else{
            stopRotation()
        }
    }
    
    /// 開始慢速旋轉
    func startSlowRotation(speed: CLLocationDirection = 1.0) {
        if timer == nil{
            mapView.userTrackingMode = .none
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self = self, let mapView = self.mapView else { return }
                let camera = mapView.camera
                camera.heading += speed   // 每次增加一點角度
                mapView.setCamera(camera, animated: true)
            }
        }else{
            stopRotation()
        }
    }

    /// 停止旋轉
    func stopRotation() {
        rotationSwitch.isOn = false
        timer?.invalidate()
        timer = nil
    }
    
    
    func showAlertForSettings() {
        let alertController = UIAlertController(title: "需要你授權使用你的位置",
                                                message: "請按下【設定頁面】並選擇【位置】-＞【使用APP期間】或【永遠】，完成之後再回到APP，以利正確定位",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "設定頁面", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let cancelAction = UIAlertAction(title: "放棄", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if trackingSwitch.isOn{
            guard let coordinate = locations.first?.coordinate else { return }
            let camera = self.mapView.camera
            camera.centerCoordinate = coordinate
            camera.altitude = Double(camHeightSlideer.value)          // 攝影機高度，數值越大縮放越小
            // 平滑動畫移動
            self.mapView.setCamera(camera, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: //未設定
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:  //已拒絕
            showAlertForSettings() // 提示使用者前往設定頁面授權
        case .authorizedAlways, .authorizedWhenInUse: // 已獲取授權
            break
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
}

//extension ViewController:MKMapViewDelegate{
//    // MARK: - MKMapViewDelegate
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let circleOverlay = overlay as? MKCircle {
//            let renderer = MKCircleRenderer(circle: circleOverlay)
//            renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.2) // 半透明填色
//            renderer.strokeColor = UIColor.systemBlue                      // 邊框顏色
//            renderer.lineWidth = 2
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//}
