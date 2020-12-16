//
//  addInfoViewController.swift
//  gbc-Project
//
//  Created by Rahul's Mac on 2020-10-27.
//

import UIKit
import Firebase
import Photos
import FirebaseStorage

class addInfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var titleInfo: UITextField!
    @IBOutlet weak var infoView: UITextView!
    var imagePicker = UIImagePickerController()
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = Storage.storage()

        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    @IBAction func imagePickerButton(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            Image.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitInfoButton(_ sender: Any) {
        if titleInfo.text != "" && infoView.text != ""{
            var ref: DocumentReference? = nil
            ref = self.db.collection("infoUpload").addDocument(data: [
                "Title-Info": self.titleInfo.text!,
                "Description" : self.infoView.text!
                
            ])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.uploadImage(self.Image.image!, refId: ref!.documentID)
                print("Document added with ID: \(ref!.documentID)")
                
            }
        }
        }
        else{
            var alert = UIAlertController(title: "Invalid Details", message: "Please enter All the credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return        }
      
}


func uploadImage(_ image:UIImage, refId : String)
{
let storageRef = Storage.storage().reference().child("Uploads/\(refId)")
guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
let metaData = StorageMetadata()
metaData.contentType = "image/jpg"

storageRef.putData(imageData, metadata: metaData) { metaData, error in
    if error == nil, metaData != nil {

        storageRef.downloadURL { url, error in
            
            self.db.collection("infoUpload").document(refId).setData(["Image" : "\(url!)"], merge: true)
            
            var alert = UIAlertController(title: "Upload Sucessfull", message:nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
}


}
    
    
    
