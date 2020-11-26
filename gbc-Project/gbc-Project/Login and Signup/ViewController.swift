//
//  ViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-02.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var appTitle: UILabel!
    
    //MARK: Constraints
    
    @IBOutlet weak var loginToAccessLabelCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usernameTFCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTFCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var notRegisteredLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonCenterConstraint: NSLayoutConstraint!
    
    //MARK: Default Functions
    
    override func viewWillAppear(_ animated: Bool) {
        loginToAccessLabelCenterConstraint.constant -= view.bounds.width
        usernameTFCenterConstraint.constant -= view.bounds.width
        passwordTFCenterConstraint.constant -= view.bounds.width
        loginButtonCenterConstraint.constant -= view.bounds.width
        notRegisteredLabelCenterConstraint.constant -= view.bounds.width
        signupButtonCenterConstraint.constant -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginToAccessLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        usernameTFCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        passwordTFCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        loginButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        notRegisteredLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        signupButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
                FirebaseApp.configure()
        }
        
        appTitle.text = ""
        var charIndex = 0.0
        let titleText = "International Student Help"
        for letter in titleText {
            
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.appTitle.text?.append(letter)
            }
            charIndex += 1
        
        }}

    @IBAction func loginButton(_ sender: UIButton) {
        if(userName.text == "jonsnow@gmail.com"){
            self.performSegue(withIdentifier: "adminLogin", sender: self)

        }
        
       else if(userName.text == "" || passWord.text == "")
        {
        let alert = UIAlertController(title: "Invalid Details", message: "Please enter valid credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            Auth.auth().signIn(withEmail: userName.text!.lowercased(), password: passWord.text!) {authResult, error in
                if(authResult != nil)
                {
                    self.performSegue(withIdentifier: "sucessLogin", sender: self)
                    self.userName.text = ""
                    self.passWord.text = ""
                }
                else{
                    
                    
                    let errCd = AuthErrorCode(rawValue: error!._code)
                    var errorAlert:String = ""
                    
                    switch errCd
                    {
                    case .wrongPassword:
                        errorAlert = "Worng Password"
                    case .invalidEmail:
                        errorAlert = "Email - Already Invalid"
                    default:
                        errorAlert = "Sign Up Unsucessfull"
                    }
                    
                    let alert = UIAlertController(title: "\(errorAlert)", message: "Please check your E-mail id or Password and try again! ", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Forgot Password", style: UIAlertAction.Style.destructive, handler: { ar in
                        if(self.userName.text != nil)
                        {
                            Auth.auth().sendPasswordReset(withEmail: self.userName.text!) { error in
                                 if(error==nil)
                                 {
                                    let alert3 = UIAlertController(title: "Reset Link Sent", message: "Please check your email to reset your password. After resetting try again.", preferredStyle: UIAlertController.Style.alert)
                                        alert3.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert3, animated: true, completion: nil)
                                 }
                                    
                                 else{
                                    
                                    print(error!)
                                 }
                            }
                        }
                        else
                        {
                            let alert2 = UIAlertController(title: "E-Mail Id Not found", message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert2, animated: true, completion: nil)
                        }
                        
                        
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
        
}

