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

    init(locationName: String, address: String, handicap: String) {
        self._locationName = locationName
        self._address = address
        self._handicap = handicap
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

        _postRef = DataService.ds.REF_VENUE.child(_postKey)

    }
}
