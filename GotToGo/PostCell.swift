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

    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var addressCell: UILabel!
    @IBOutlet weak var handicapLbl: UILabel!

    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post){
        self.post = post
        self.nameCell.text = post.locationName
        self.addressCell.text = post.address
        self.handicapLbl.text = post.handicap
    }


}
