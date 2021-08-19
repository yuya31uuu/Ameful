//
//  MapViewController.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/07/22.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MapViewを生成.
        var myMapView: MKMapView = MKMapView()
        myMapView.frame = self.view.frame
        
        // 新宿の経度、緯度.
        let myLatitude: CLLocationDegrees = 35.690921
        let myLongitude: CLLocationDegrees = 139.70025799999996
        
        // 中心点.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        
        // MapViewに中心点を設定.
        myMapView.setCenter(center, animated: true)
        
        // 表示領域.
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)
        
        // MapViewにregionを追加.
        myMapView.region = myRegion
        
        // viewにMapViewを追加.
        self.view.addSubview(myMapView)
        
        // ピンを生成.
        var myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = center
        
        // タイトルを設定.
        myPin.title = "タイトル"
        
        // サブタイトルを設定.
        myPin.subtitle = "サブタイトル"
        
        // MapViewにピンを追加.
        myMapView.addAnnotation(myPin)
        
        
    }
    
    
}
