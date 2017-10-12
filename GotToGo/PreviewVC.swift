//
//  Preview.swift
//  GotToGo
//
//  Created by HSI on 9/4/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var previewMap: MKMapView!

    private var _locationData: Post!
    private var _addressLbl: Post!
    private var _latitude: Post!
    private var _longitude: Post!

    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var centerMapped = false


//Get & Set
    var locationData: Post {
        get {
            return _locationData
        } set {
            _locationData = newValue

        }
    }

    var addressData: Post {
        get {
            return _addressLbl
        } set {
            _addressLbl = newValue
        }
    }

    var latitude: Post {
        get {
            return _latitude
        } set {
            _latitude = newValue
        }
    }


    var longitude: Post {
        get {
            return _longitude
        } set {
            _longitude = newValue
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Map
         previewMap.delegate = self
         previewMap.userTrackingMode = MKUserTrackingMode.follow

        //Set Labels
        locationLbl.text =  locationData.locationName.capitalized
        addressLbl.text = addressData.address.capitalized



    }


   
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    //MapView Focus
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)

        previewMap.setRegion(coordinateRegion, animated: true)
    }


    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !centerMapped {
                centerMapOnLocation(location: loc)
                centerMapped = true
            }
        }
    }

    //Annotation Override.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let lat: CLLocationDegrees = (latitude) as! CLLocation
        let long: CLLocationDegrees = (longitude)as! CLLocation

        //User Annotation
        if (annotation is MKUserLocation) {
            return nil
        }

        //Venue Annotation
        let reuseId = "Image"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotation.coordinate = CLLocationCoordinate2DMake(latitude: latitude, longitude: longitude)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "Marker")
        }
        else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    @IBAction func openMap(_ sender: Any) {

        
    }
}
