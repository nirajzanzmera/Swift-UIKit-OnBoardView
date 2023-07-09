//
//  RadiusVC.swift
//  OnBoardView
//
//  Created by Zignuts Technolab on 28/04/23.
//

import UIKit
import MapKit
import CoreLocation

class RadiusVC: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView! {
        didSet {
            self.mapKit.showsUserLocation = true
            self.mapKit.delegate = self
        }
    }
    @IBOutlet weak var leftToRight: PipeSlider! {
        didSet {
            self.leftToRight.delegate = self
            self.leftToRight.direction = .leftToRight
        }
    }
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startMonitoringSignificantLocationChanges()
        return manager
    }()
    var circleRadius: CLLocationDistance = 1
    let circle = MKCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension RadiusVC {
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
    }
}

extension RadiusVC: PipeSliderDelegate {
    func pipeView(_ sender: PipeSlider, didChanged value: Double) {
        print("Value: \(value)")
        let newRadius = CLLocationDistance(value*0.15)
        if newRadius != circleRadius {
            circleRadius = newRadius
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
}

extension RadiusVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = UIImage(systemName: "camera.fill")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}

extension RadiusVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: circleRadius, longitudinalMeters: circleRadius)
        mapKit.setRegion(region, animated: true)
        
        let newCircle = MKCircle(center: location.coordinate, radius: circleRadius)
        mapKit.removeOverlays(mapKit.overlays)
        mapKit.addOverlay(newCircle)
        
        mapKit.showsUserLocation = true
    }
}
