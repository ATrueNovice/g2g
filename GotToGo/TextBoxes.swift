//
//  TextBoxes.swift
//  Relief
//
//  Created by New on 6/6/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class TextBoxes: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }

    //Modifies the place holder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
