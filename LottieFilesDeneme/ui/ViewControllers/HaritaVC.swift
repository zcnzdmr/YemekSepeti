//
//  HaritaVC.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 16.03.2024.
//

import UIKit
import CoreLocation
import MapKit

class HaritaVC: UIViewController {
    
    
    @IBOutlet weak var mapKitKurye: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.self.navigationItem.title = "Kuryem Nerede"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
        
        
        
        //39.9800446,32.820361
        let konum = CLLocationCoordinate2D(latitude: 39.9827094, longitude: 32.824415)
        let konum2 = CLLocationCoordinate2D(latitude: 39.9800446, longitude: 32.820361)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let bolge = MKCoordinateRegion(center: konum, span: span)
        mapKitKurye.setRegion(bolge, animated: true)
        
        
        let pin = MKPointAnnotation()
        pin.coordinate = konum
        pin.title = "Konumunuz"
        pin.subtitle = "Ev"
        mapKitKurye.addAnnotation(pin)
        
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate = konum2
        pin2.title = "Konumunuz"
        pin2.subtitle = "İş Yeri"
        mapKitKurye.addAnnotation(pin2)
    }

}
extension HaritaVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let sonKonum = locations[locations.count-1]
        
        let enlem = sonKonum.coordinate.latitude
        let boylam = sonKonum.coordinate.longitude
        //let hiz = sonKonum.speed

        let konum = CLLocationCoordinate2D(latitude: enlem, longitude: boylam)
        //let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let bolge = MKCoordinateRegion(center: konum, latitudinalMeters: 2000, longitudinalMeters: 2000)
        //let bolge = MKCoordinateRegion(center: konum, span: span)
        mapKitKurye.setRegion(bolge, animated: true)
        
        mapKitKurye.showsUserLocation = true
    }
}
