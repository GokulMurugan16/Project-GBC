//
//  ProfileViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-24.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {
    
    // MARK: Variables
    
    var handle: AuthStateDidChangeListenerHandle?
    var userId:String?
    var userName:String?
    var phone:String?
    var imageUrl:String?
    var email:String?
    var db:Firestore!
    
    // MARK: Outlets
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    // MARK: Default Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            let user = Auth.auth().currentUser
            if let user = user {
                self.userId = user.uid
                self.getUserData()
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
        let docRef: Void = db.collection("users").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error Getting Documents \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data()) ")
                        let data = document.data()
                        
                        self.userName = data["userName"] as! String?
                        self.phone = data["phone"] as! String?
                        self.imageUrl = data["image"] as! String?
                        self.email = data["eMail"] as! String?
                        
                        self.emailLabel.text = self.email
                        self.userNameTF.text = self.userName
                        self.phoneTF.text = self.phone
                        
                        print("\(self.userName!) \(self.phone!)")
                        
                    }
                }
            }
    }

}
