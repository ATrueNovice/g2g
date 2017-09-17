//
//  Preview.swift
//  GotToGo
//
//  Created by HSI on 9/4/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {

    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!

    private var _locationData: Post!
    private var _addressLbl: Post!



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




    override func viewDidLoad() {
        super.viewDidLoad()

        locationLbl.text =  locationData.locationName
        addressLbl.text = addressData.address
    }

}
