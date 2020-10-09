//
//  SignUpViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-08.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var pNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
