//
//  ViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-02.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var testDisplay: UILabel!
    @IBOutlet weak var passWord: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        Displayname()
        
        
    }
    
    func Displayname(){
        testDisplay.text = "User Name : \(userName.text!) \nPassword : \(passWord.text!)"
    }
    
    
}

