//
//  ViewController.swift
//  maps_project
//
//  Created by Rahul on 05/04/22.
//

import UIKit
import MapKit
import CoreLocation


class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}


class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //create two dummy locations
    let kochi = CLLocationCoordinate2D.init(latitude: 9.931233, longitude: 76.267303)
    let combt = CLLocationCoordinate2D.init(latitude: 11.017363, longitude: 76.958885)
    let madurai = CLLocationCoordinate2D.init(latitude: 9.939093, longitude: 78.121719)
    let munnar = CLLocationCoordinate2D.init(latitude: 10.089167, longitude: 77.059723)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        //find route
        showRouteOnMap(pickupCoordinate: kochi, destinationCoordinate: combt)
        showRouteOnMap(pickupCoordinate: combt, destinationCoordinate: madurai)
        showRouteOnMap(pickupCoordinate: madurai, destinationCoordinate: munnar)
        showRouteOnMap(pickupCoordinate: munnar, destinationCoordinate: kochi)
        
        self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true

            if let coor = mapView.userLocation.location?.coordinate{
                mapView.setCenter(coor, animated: true)
            }
        
        // Show artwork on map
//        let artwork = Artwork (
//          title: "Happy Journy",
//          locationName: "Kochin",
//          discipline: "",
//          coordinate: CLLocationCoordinate2D(latitude: 9.931233, longitude: 76.267303))
//        mapView.addAnnotation(artwork)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 9.931233, longitude: 76.267303)
        annotation1.title = "Kochin"
        annotation1.subtitle = "current location"
        mapView.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 11.017363, longitude: 76.958885)
        annotation2.title = "Coimbatore"
        annotation2.subtitle = "current location"
        mapView.addAnnotation(annotation2)
        
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 9.939093, longitude: 78.121719)
        annotation3.title = "Madurai"
        annotation3.subtitle = "current location"
        mapView.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 10.089167, longitude: 77.059723)
        annotation4.title = "Munnar"
        annotation4.subtitle = "current location"
        mapView.addAnnotation(annotation4)
        
        
        
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//        mapView.mapType = MKMapType.standard
//        let span = MKCoordinateSpan(latitudeDelta: 9.931233, longitudeDelta: 76.267303)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        mapView.setRegion(region, animated: true)
//        centerMap(locValue)
//
//    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                //for getting just one route
                if let route = unwrappedResponse.routes.first {
                    //show on map
                    self.mapView.addOverlay(route.polyline)
                    //set the map area to show the route
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }

                //if you want to show multiple routes then you can get all routes in a loop in the following statement
                //for route in unwrappedResponse.routes {}
            }
        }
    
    //this delegate function is for displaying the route overlay and styling it
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.systemBlue
         renderer.lineWidth = 7.0
         return renderer
    }


}

