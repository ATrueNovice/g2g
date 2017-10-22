//
//  ForgotPassword.swift
//  GotToGo
//
//  Created by HSI on 10/3/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import Foundation
import Firebase

class ForgotPassword: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: TextBoxes!

    override func viewDidLoad() {
        self.emailField.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPassword.dismissKeyboard))

        view.addGestureRecognizer(tap)

        super.viewDidLoad()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }


    @IBAction func resetPwd(_ sender: Any) {
        if let email = emailField.text {
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                OperationQueue.main.addOperation {

                if error != nil {

                    // Error - Unidentified Email
                    let alert = UIAlertController(title: "Hmmm...", message: "This Email Doesn't Look Like It's Registered. Try Another One.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    }))
                    self.present(alert, animated: true, completion: nil)


                } else {

                    // Success - Sends recovery email
                    let alert = UIAlertController(title: "Email Sent", message: "An email has been sent. Please, check your email now.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }

            }})
    }

    }
}
