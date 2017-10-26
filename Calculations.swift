//
//  calculations.swift
//  GotToGo
//
//  Created by HSI on 10/24/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import Foundation
import Firebase

class Calculations {

    var posts = [Post]()




    func calculateDistance(userlat: CLLocationDegrees, userLon:CLLocationDegrees, venueLat:CLLocationDegrees, venueLon:CLLocationDegrees) -> String {
        let userLocation:CLLocation = CLLocation(latitude: userlat, longitude: userLon)
        let priceLocation:CLLocation = CLLocation(latitude: venueLat, longitude: venueLon)
        let distance = String(format: "%.0f", userLocation.distance(from: priceLocation)/1000)
        return distance
    }
}
