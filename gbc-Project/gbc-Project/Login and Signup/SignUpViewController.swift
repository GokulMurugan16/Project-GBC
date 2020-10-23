//
//  SignUpViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-08.
//

import UIKit
import Firebase
import FirebaseStorage
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
        imageView?.layer.cornerRadius = (imageView?.frame.size.width ?? 0.0) / 2
        imageView?.clipsToBounds = true
        imageView?.layer.borderWidth = 3.0
        imageView?.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "proPic")
        
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
                    "userId": uId,
                    "image" : self.uploadProfileImage(self.imageView.image!, uid: uId)
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Data Added Sucessfully")
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
        
        
        
        if UIImagePickerController.isSourceTypeAvailable( .photoLibrary) {

                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.present(imagePickerController, animated: true, completion: nil)
                }
    
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            self.dismiss(animated: true) { [weak self] in

                guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
                
                self?.imageView.image = image
            }
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    func uploadProfileImage(_ image:UIImage, uid : String) -> URL?
    {
        
        var downURL:URL!
        let storageRef = Storage.storage().reference().child("user/\(uid)")

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return downURL}


        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {

                storageRef.downloadURL { url, error in
                    print(url)
                    downURL = url!
                }
            }
        }
        return downURL
    }
    
    
}


