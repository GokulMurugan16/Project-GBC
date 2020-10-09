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
        if FirebaseApp.app() == nil {
                FirebaseApp.configure()
        }
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        if(userName.text == "" || passWord.text == "")
        {
            var alert = UIAlertController(title: "Invalid Details", message: "Please enter valid credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                    var alert = UIAlertController(title: "User Not Found", message: "Please check your E-mail id or Password and try again! ", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
        
}

