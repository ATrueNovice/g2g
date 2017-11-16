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
import GoogleMobileAds

class PointAnnotation : MKPointAnnotation {
    var post : Post!
}
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bannerView: GADBannerView!
    

    let locationManager = CLLocationManager()
    var centerMapped = false

    //GeoFire
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!


    //Array With data from FireBase
    var posts = [Post]()
    var postData = [String:AnyObject]()
    var userLatt = CLLocationDegrees()
    var userLonn = CLLocationDegrees()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Map
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.showsUserLocation = true

        //Google Ad Mob
        bannerView.adUnitID = "ca-app-pub-8509730756658652/8064528485"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        //Geofire
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)

        // Setup TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self

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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 7500, 7500)

        mapView.setRegion(coordinateRegion, animated: true)
    }

    //User clicked callout button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let point = view.annotation as? PointAnnotation {
            performSegue(withIdentifier: "previewSegue", sender: point.post)
        }
    }

    //Update the suer location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !centerMapped {
                self.userLatt = userLocation.coordinate.latitude
                self.userLonn = userLocation.coordinate.longitude
                populateData()
                centerMapOnLocation(location: loc)
                centerMapped = true
            }
            geoFire.setLocation(CLLocation(latitude: self.userLatt, longitude: self.userLonn), forKey: "userLocation") { (error) in
                if (error != nil) {
                    print("An error occured: \(String(describing: error))")
                } else {
                    print("Saved location successfully!", self.userLatt, self.userLonn)
                }
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
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "Marker")

            let subtitleView = UILabel()
            subtitleView.font = subtitleView.font.withSize(12)
            subtitleView.numberOfLines = 2
            subtitleView.text = annotation.subtitle!
            annotationView?.detailCalloutAccessoryView = subtitleView
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        }
        else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func calculateDistance(userlat: CLLocationDegrees, userLon:CLLocationDegrees, venueLat:CLLocationDegrees, venueLon:CLLocationDegrees) -> Double {
        let userLocation:CLLocation = CLLocation(latitude: userlat, longitude: userLon)
        let priceLocation:CLLocation = CLLocation(latitude: venueLat, longitude: venueLon)
        _ = String(format: "%.0f", userLocation.distance(from: priceLocation)/1000)
        return userLocation.distance(from: priceLocation)/1000


    }



    func getDataForMapAnnotation(){

        posts.forEach { post in

            let center = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
            _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75))

            let annotation = PointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(post.latitude, post.longitude)
            annotation.title = post.locationName.capitalized
            annotation.subtitle = "Handicap Access " + post.handicap.capitalized
            annotation.post = post
            self.mapView.addAnnotation(annotation)
        }

    }

    func populateData() {

        //Pulls TableData for UITableView
        DataService.ds.REF_VENUE.observe(.value, with: { (snapshot) in

            self.posts = [] // THIS IS THE NEW LINE

            if snapshot.exists(){
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {

                        if let snapValue = snap.value as? [String:AnyObject],
                            let venueLat = snapValue["LATITUDE"] as? Double,
                            let venueLong = snapValue["LONGITUDE"] as? Double
                        {
                            let distance = self.calculateDistance(userlat: self.userLatt, userLon: self.userLonn, venueLat: venueLat, venueLon: venueLong)

                            if distance <= 2 {
                                let key = snap.key
                                let post = Post(postKey: key, postData: snapValue)
                                post.distance = distance
                                self.posts.append(post)
                            }
                        }
                    }

                    if self.posts.count == 0 {
                        let alert = UIAlertController(title: "Oh No!!!", message: "It Looks Like We Haven't Mapped Your Town Yet. Please Go To The More Info tab and Request Your Town mapped!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.getDataForMapAnnotation()
                }

                self.posts.sort {
                    $0.distance < $1.distance
                }

                self.tableView.reloadData()

            }
        })
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
        GIDSignIn.sharedInstance().signOut()
        print("NOTE: Key Forgotten \(keychainMessage)")
        self.dismiss(animated: false, completion: nil)

    }

}

