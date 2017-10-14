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

    private var locationData: Post!

    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var centerMapped = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Map
         previewMap.delegate = self
         previewMap.userTrackingMode = MKUserTrackingMode.follow

        //Set Labels
        locationLbl.text =  locationData.locationName.capitalized
        addressLbl.text =  locationData.address.capitalized
        print("here: \(locationData.address.capitalized)")

    }

    func initData(selectedPost: Post) {
        locationData = selectedPost
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

        //User Annotation
        if (annotation is MKUserLocation) {
            return nil
        }

        //Venue Annotation
        let reuseId = "Image"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotation.coordinate = CLLocationCoordinate2DMake(latitude: locationData.latitude, longitude: locationData.longitude)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "Marker")
        }
        else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    @IBAction func openMap(_ sender: Any) {


        let regionDistance: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 500, longitudeDelta: 500)
        let coordinate =  CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)

        let regionSpan = MKCoordinateRegionMake(coordinate, regionDistance)

        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)]

        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)

        mapItem.name = locationData.locationName
//        mapItem.openInMaps(launchOptions: options)

    }
}

