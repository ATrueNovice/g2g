//
//  Preview.swift
//  GotToGo
//
//  Created by HSI on 9/4/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {

    @IBOutlet weak var locationClickedLbl: UILabel!
    @IBOutlet weak var addressClickedLbl: UILabel!

    private var _locationData: Post!
    private var _addressData: Post!



    var locationData: Post {
        get {
            return _locationData
        } set {
            _locationData = newValue

        }
    }

    var addressData: Post {
        get {
            return _addressData
        } set {
          _addressData = newValue
        }
    }




    override func viewDidLoad() {
        super.viewDidLoad()

    locationClickedLbl.text =  locationData.locationName
      addressClickedLbl.text = addressData.address

    }
}
