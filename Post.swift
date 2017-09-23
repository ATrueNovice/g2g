//
//  Post.swift
//  GotToGo
//
//  Created by HSI on 9/3/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import Foundation
import Firebase


class Post {

    private var _locationName: String!
    private var _address: String!
    private var _handicap: String!
    private var _postKey: String!
    private var _latitude: Double!
    private var _longitude: Double!
    private var _postRef: DatabaseReference!


    var locationName: String {
        return _locationName
    }

    var address: String {
        return _address
    }

    var handicap: String {
        return _handicap
    }

    var postKey: String {
        return _postKey
    }

    var latitude: Double {
        return _latitude
    }

    var longitude: Double {
        return _longitude
    }

    init(locationName: String, address: String, handicap: String) {
        self._locationName = locationName.capitalized
        self._address = address.capitalized
        self._handicap = handicap.capitalized
        self._latitude = latitude
        self._longitude = longitude
    }

    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey

        if let locationName = postData["NAME"] as? String {
            self._locationName = locationName

        }

        if let address = postData["ADDRESS"] as? String {
            self._address = address
        }

        if let handicap = postData["HANDICAP"] as? String {
            self._handicap = handicap
        }

        if let latitude = postData["LATITUDE"] as? Double {
            self._latitude = latitude
        }

        if let longitude = postData["LONGITUDE"] as? Double {
            self._longitude = longitude
        }

        _postRef = DataService.ds.REF_VENUE.child(_postKey)

    }
}
