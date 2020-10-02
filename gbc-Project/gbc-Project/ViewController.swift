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
    @IBOutlet weak var errorDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        if(userName.text == "" || passWord.text == "")
        {
            errorDisplay.text = "Please enter valid credentials"
            return
        }
        else{
            Auth.auth().signIn(withEmail: userName.text!.lowercased(), password: passWord.text!) {authResult, error in
                if(authResult != nil)
                {
                    print("User Found")
                    self.errorDisplay.text = "User Found"
                    self.userName.text = ""
                    self.passWord.text = ""
                }
                else{
                    print("User Not Found")
                    self.errorDisplay.text = "User Not Found"
                    self.userName.text = ""
                    self.passWord.text = ""
                }
            }
            
            
            
            
        }
        
        
        
        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        print("SignUp Button Selected")
    }
    
    
    
        
    
    
    
}

