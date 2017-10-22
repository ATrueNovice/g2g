//
//  DataService.swift
//  GotToGo
//
//  Created by HSI on 9/3/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()

class DataService {

    static let ds = DataService()

    //DB References

    private var _REF_BASE = DB_BASE
    private var _REF_VENUE = DB_BASE.child("venue")
    private var _REF_USERS = DB_BASE.child("users")



    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }

    var REF_VENUE: DatabaseReference {
        return _REF_VENUE
    }

    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }


    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }


    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //This function creates a new user based on the parameters uid & userdata to build out the array. Thats why we put userData as a dictionary. To add likes, photos, and other information based on the array in the data base.

        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    


}
