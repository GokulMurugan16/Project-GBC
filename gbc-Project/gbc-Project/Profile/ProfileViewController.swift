//
//  ProfileViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-29.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Variables
    
    var handle: AuthStateDidChangeListenerHandle?
    var userId:String?
    var userName:String?
    var phone:String?
    var imageUrl:String?
    var email:String?
    var db:Firestore!
    let storage = Storage.storage().reference()
    
    
    // MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    // MARK: Constraints
    @IBOutlet weak var profileLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadPhotoCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var updateButtonCenterConstraint: NSLayoutConstraint!
    
    
    // MARK: Default Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        profileImageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            let user = Auth.auth().currentUser
            if let user = user {
                self.userId = user.uid
                self.getUserData()
            }
        })
        
        // Setting all the items outside of safeAreaView
        profileLabelCenterConstraint.constant -= view.bounds.width
        profileImageCenterConstraint.constant -= view.bounds.width
        uploadPhotoCenterConstraint.constant -= view.bounds.width
        emailLabelCenterConstraint.constant -= view.bounds.width
        updateButtonCenterConstraint.constant -= view.bounds.width
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        profileLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        profileImageCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        uploadPhotoCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        emailLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        updateButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: Segue Functions
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    // MARK: Photo Functions
    
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
            storage.child("user/\(userId).png").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload the image.")
                return
            }
                
                self.storage.child("user/\(self.userId).png").downloadURL { (url, error) in
                    guard let url = url , error == nil else {
                        return
                    }
                    
                    let urlString = url.absoluteString
                    print("Download URL: \(urlString)")
                    self.imageUrl = urlString
                    
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            
        }
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func downloadImage(urlString:String) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.profileImageView.image = image
            }
        }
        
        task.resume()
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
                        
                        self.userName = (data["userName"] as! String?)!
                        self.phone = (data["phone"] as! String?)!
                        self.imageUrl = (data["image"] as! String?)!
                        self.email = (data["eMail"] as! String?)!
                        
                        self.emailLabel.text = self.email
                        self.userNameTF.text = self.userName
                        self.phoneTF.text = self.phone
                        
                        print("\(self.userName!) \(self.phone!)")
                        self.downloadImage(urlString: self.imageUrl!)
                        
                    }
                }
            }
    }
    
    @IBAction func updateUserData(_ sender: UIButton) {
        
        db.collection("users").document("\(userId!)").setData([
            "eMail" : "\(email!)",
            "phone" : "\(phoneTF.text!)",
            "userId": "\(userId!)",
            "userName": "\(userNameTF.text!)",
            "image" : "\(imageUrl!)"
            
        ]) { err in
            if let err = err {
                print("Error writing document : \(err)")
                self.displayAlert(title: "Error", message: "Cannot update your profile.")
            }
            else {
                print("Document successfully written")
                self.displayAlert(title: "Success", message: "Your profile is updated.")
            }
        }
    }
    
    // MARK: Display Alert Function
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    

}
