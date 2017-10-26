//
//  PostCell.swift
//  GotToGo
//
//  Created by HSI on 9/3/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var handicapLbl: UILabel!

    var post: Post!


    func configureCell(post: Post){
        self.post = post
        self.nameLbl.text = post.locationName.capitalized
        self.addressLbl.text = post.address.capitalized
        self.handicapLbl.text = post.handicap.capitalized
        
    }


}

