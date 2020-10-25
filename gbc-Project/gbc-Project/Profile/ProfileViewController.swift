//
//  ProfileViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-24.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var userId:String?
    var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            let user = Auth.auth().currentUser
            if let user = user {
                self.userId = user.uid
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: Segue Functions
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    // MARK: User Information Functions
    
    func getUserData() {
        let docRef = db.collection("users").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error Getting Documents \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data()) ")
                    }
                }
            }
    }

}
