//
//  ViewController.swift
//  TryInstagram
//
//  Created by Charles Lim on 3/8/17.
//  Copyright © 2017 RegaCity. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JESS: Unable to authenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("JESS: user cancel facebook authentication")
            } else {
                print("JESS: Successfully authientication with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JESS: unable to authenticated with Firebase - \(error)")
            } else {
                print("JESS: Success authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                    print(user.uid)
                }
                
            }
        })
    }
    
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text {
            
            if let pwd = pwdField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    
                    if error == nil {
                        print("JESS: Email user authenticated with Firebase")
                        if let user = user {
                            self.completeSignIn(id: user.uid)
                        }
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            
                            if error != nil {
                                print("JESS: Unable to authenticated with Firebase using email!")
                            } else {
                                print("JESS: Successful authrnticated with Firebase")
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    func completeSignIn(id: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set("\(id)", forKey: "uid")
        print("JESS: Data saved to keychain \(saveSuccessful)")
        performSegue(withIdentifier: "gotoFeed", sender: nil)
    }

    
    
}

