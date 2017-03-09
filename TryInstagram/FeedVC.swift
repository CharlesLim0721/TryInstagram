//
//  FeedVC.swift
//  TryInstagram
//
//  Created by Charles Lim on 3/9/17.
//  Copyright © 2017 RegaCity. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOut(_ sender: AnyObject) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID Remove from Keychain \(removeSuccessful)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    

}
