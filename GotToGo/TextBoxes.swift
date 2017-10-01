//
//  TextBoxes.swift
//  Relief
//
//  Created by New on 6/6/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class TextBoxes: UITextField, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }

    //Modifies the place holder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 10)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 10)
    }

    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

}
