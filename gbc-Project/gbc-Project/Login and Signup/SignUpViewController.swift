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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Signup"
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.imageTapped))
        
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView?.layer.cornerRadius = (imageView?.frame.size.width ?? 0.0) / 2
        imageView?.clipsToBounds = true
        imageView?.layer.borderWidth = 3.0
        imageView?.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tap(_ sender: Any) {
        
        view.endEditing(true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        
        if(userName.text == "" || passWord.text == "" || eMail.text == "" || pNumber.text == "")
        {
            let alert = UIAlertController(title: "Invalid Details", message: "Please enter valid credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else{
        
        Auth.auth().createUser(withEmail: eMail.text!, password: passWord.text!) {authResult, error in
            if(authResult != nil)
            {
                print(authResult!)
                let alert = UIAlertController(title: "Sign Up Sucessfull!", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
                let uId = authResult!.user.uid
                
                self.uploadProfileImage(self.imageView.image!, uid: uId)
                
            }
            else{
                
                let errCd = AuthErrorCode(rawValue: error!._code)
                var errorAlert:String = ""
                
                switch errCd
                {
                case .emailAlreadyInUse:
                    errorAlert = "Email - Already in Use"
                case .invalidEmail:
                    errorAlert = "Email ID Invalid"
                case .weakPassword:
                    errorAlert = "Password must be atleast 6 characters"
                default:
                    errorAlert = "Sign Up Unsucessfull"
                }
                
                let alert = UIAlertController(title: "\(errorAlert)", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                ViewController.signedIn = false
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
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
    
    func uploadProfileImage(_ image:UIImage, uid : String)
    {
        let storageRef = Storage.storage().reference().child("user/\(uid)")

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}


        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        metaData.contentType = "image/png"

        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {

                storageRef.downloadURL { url, error in
                    print(url!)
                    
                    self.db.collection("users").addDocument(data: [
                        "userName": self.userName.text!,
                        "eMail": self.eMail.text!,
                        "phone": self.pNumber.text!,
                        "userId": uid,
                        "image" : "\(url!)"
                    ])
                    { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Data Added Sucessfully")
                        }
                    }
                    
                    self.userName.text = ""
                    self.passWord.text = ""
                    self.eMail.text = ""
                    self.pNumber.text = ""
                    self.imageView.image = UIImage(named: "person.fill")
                    
                }
            }
        }
    }
    
    
}


