//
//  New User.swift
//  GotToGo
//
//  Created by HSI on 10/1/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Firebase

class newUser: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newUser.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }


    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //EMAIL SIGN IN
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("NOTE: Email User Created")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            // Error - Unidentified Email
                            let alert = UIAlertController(title: "This Email May Have Been Used Before.", message: "Could You Please Verify That This Is the Correct Email", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print("NOTE: Unable to authenticate with Firebase using email")

                        } else {
                            print("NOTE: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }

    //SIGN IN CHECK

    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("NOTE: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }


}

