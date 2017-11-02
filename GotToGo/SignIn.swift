//
//  GotToGo
//
//  Created by HSI on 9/2/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SignIn: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {



    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            print("NOTE: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
                return
            }
            self.firebaseAuth(credential)
        }
    }

        @IBAction func googleBtnTapped(_ sender: Any) {
            GIDSignIn.sharedInstance().signIn()
    }
    

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {

        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("NOTE: Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("NOTE: User cancelled Facebook authentication")
            } else {
                print("NOTE: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


//AUTHENTICATION CHECK
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("NOTE: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("NOTE: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }





    //EMAIL SIGN IN
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("NOTE: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            // Error - Unidentified Email
                            let alert = UIAlertController(title: "Hmmm...", message: "Invaild User Name or Password", preferredStyle: UIAlertControllerStyle.alert)
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

    @IBAction func noAccount(_ sender: Any) {
        performSegue(withIdentifier: "goNewUser", sender: nil)


    }


}

