//
//  ViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-02.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        
    }

    @IBAction func loginButton(_ sender: UIButton) {
        Displayname()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        print("SignUp Button Selected")
    }
    
    
    func Displayname(){
        print("User Name : \(userName.text!) \nPassword : \(passWord.text!)")
        Auth.auth().signIn(withEmail: userName.text!.lowercased(), password: passWord.text!) {authResult, error in
//          guard let strongSelf = self else { return }
            print(error)
            print(authResult)
        }
        userName.text = ""
        passWord.text = ""
    }
    
    
}

