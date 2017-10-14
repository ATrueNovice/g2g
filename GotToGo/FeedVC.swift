//
//  FeedVC.swift
//  GotToGo
//
//  Created by HSI on 9/3/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!


    let locationManager = CLLocationManager()
    var centerMapped = false
 


//Array With data from FireBase
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Map
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow

        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self

        //Pulls TableData for UITableView
        DataService.ds.REF_VENUE.observe(.value, with: { (snapshot) in

            self.posts = [] // THIS IS THE NEW LINE
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }

                    //Populates Map with annotations.
                    if let locationDict = snap.value as? Dictionary<String, AnyObject> {

                        let lat = locationDict["LATITUDE"] as! CLLocationDegrees
                        let long = locationDict["LONGITUDE"] as! CLLocationDegrees
                        let title = locationDict["NAME"] as! String
                        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20))

                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                        annotation.title = title.capitalized
                        self.mapView.addAnnotation(annotation)


                    }
                }
            }
            self.tableView.reloadData()
        })
    }


    //Brings up the user on the map after authorization
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }


    //Checks if app is authorized to get user's location data.
    func locationAuthStatus () {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {

            mapView.showsUserLocation = true

        } else {
            locationManager.requestWhenInUseAuthorization()
        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }



//MapView Focus
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)

        mapView.setRegion(coordinateRegion, animated: true)
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
        if annotation.isKind(of: MKUserLocation.self) {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "icon")
            return annotationView
        }

        //Venue Annotation
        let reuseId = "Image"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "Marker")
        }
        else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

//TableView Configure

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? PostCell {
        let cellData = posts[indexPath.row]

        cell.configureCell(post: cellData)
            return cell
        } else {
            return PostCell()
        }
    }


//TableView Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        performSegue(withIdentifier: "previewSegue", sender: post)
    }

    //MapView Segue
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        performSegue(withIdentifier: "previewSegue", sender: posts[indexPath.])
//    }

// Sender with Location Name and Address
    // Sender with Location Name and Address
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            if let destination = segue.destination as? PreviewVC {
                if let update = sender as? Post {
                    destination.initData(selectedPost: update)
                }
            }
        }
    }


//SignOut
    @IBAction func buttonPressed(_ sender: Any) {

        let keychainMessage = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try!  Auth.auth().signOut()
        print("NOTE: Key Forgotten \(keychainMessage)")
        self.dismiss(animated: false, completion: nil)

    }

}
