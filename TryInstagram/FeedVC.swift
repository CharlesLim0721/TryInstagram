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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value)
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID Remove from Keychain \(removeSuccessful)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    

}
