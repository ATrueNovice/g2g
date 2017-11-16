//
//  Preview.swift
//  GotToGo
//
//  Created by HSI on 9/4/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds
import StoreKit

class PreviewVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, GADInterstitialDelegate  {

    @IBOutlet weak var pLocationLbl: UILabel!
    @IBOutlet weak var pAddressLbl: UILabel!
    @IBOutlet weak var previewMap: MKMapView!
    @IBOutlet weak var bannerView: GADBannerView!



    private var locationData: Post!
    var interstitial: GADInterstitial!

    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var centerMapped = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Map
        previewMap.delegate = self
        previewMap.userTrackingMode = MKUserTrackingMode.follow

        //Set Labels
        pLocationLbl.text =  locationData.locationName.capitalized
        pAddressLbl.text =  locationData.address.capitalized
        print("Location Selected: \(locationData.address.capitalized)")

        //Google Ad Mob
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8509730756658652/4125283471")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self


        bannerView.adUnitID = "ca-app-pub-8509730756658652/2175966466"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())


        //Map Data
        let lat = locationData.latitude
        let long = locationData.longitude
        let title = locationData.locationName
        let handi = locationData.handicap
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
        annotation.title = title.capitalized
        annotation.subtitle = "Handicap Access " + handi
        self.previewMap.addAnnotation(annotation)
        self.previewMap.setRegion(region, animated: true)

        //In App Review
        SKStoreReviewController.requestReview()

    }

    //Initialize Passed Data
    func initData(selectedPost: Post) {
        locationData = selectedPost
    }

    //Dismiss View
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    

    //MapView Focus
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)

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

    //To Be Used Later
    func iAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
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

        }
        else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    //AdMob
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8509730756658652/4125283471")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }

    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("Ad presented")
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }

    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }

    //Admob Errors
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }



    //Open In Native Map
    @IBAction func openMap(_ sender: Any) {

        let regionDistance: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 500, longitudeDelta: 500)
        let coordinate =  CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)

        let regionSpan = MKCoordinateRegionMake(coordinate, regionDistance)

        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]

        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)

        mapItem.name = locationData.locationName
        mapItem.openInMaps(launchOptions: options)

    }
}

