//
//  SignUpViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-08.
//

import UIKit
import Firebase
import Photos

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let db = Firestore.firestore()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var pNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.imageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if(userName.text == "" || passWord.text == "" || eMail.text == "" || pNumber.text == "")
        {
            var alert = UIAlertController(title: "Invalid Details", message: "Please enter valid credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else{
        
        Auth.auth().createUser(withEmail: eMail.text!, password: passWord.text!) {authResult, error in
            if(authResult != nil)
            {
                print(authResult)
                var alert = UIAlertController(title: "Sign Up Sucessfull!", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "login", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
                var uId = Auth.auth().currentUser!.uid
                var ref: DocumentReference? = nil
                ref = self.db.collection("users").addDocument(data: [
                    "userName": self.userName.text!,
                    "eMail": self.eMail.text!,
                    "phone": self.pNumber.text!,
                    "userId": uId
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                
                self.userName.text = ""
                self.passWord.text = ""
                self.eMail.text = ""
                
            }
            else{
                print(error)
                
            }
        }
        
        }
    }
    
    
    @objc func imageTapped(){
        
        
        let photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photosAuthorizationStatus == .authorized{
            
        
        }
        
        else if photosAuthorizationStatus == .notDetermined {
        PHPhotoLibrary.requestAuthorization({status in
        if status == .authorized {
            
        }})}
        else {
            print("Error In Opening Photo Library 2")
        }
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    
}


