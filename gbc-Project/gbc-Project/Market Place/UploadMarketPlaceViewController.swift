//
//  UploadMarketPlaceViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-15.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadMarketPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var posterName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var uploadDesc: UITextField!
    
    var uploadTitle:String = ""
    var db = Firestore.firestore()
    var imagePicker = UIImagePickerController()
    var indicator:UIActivityIndicatorView = UIActivityIndicatorView()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Posting"
        let tap = UITapGestureRecognizer(target: self, action: #selector(UploadMarketPlaceViewController.imageTapped))
        imageView.addGestureRecognizer(tap)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func tap(_ sender: Any) {
        
        view.endEditing(true)
        
    }
    
    @objc func imageTapped(){
        //startIndicator()
        if UIImagePickerController.isSourceTypeAvailable( .photoLibrary) {

                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.present(imagePickerController, animated: true, completion: nil)
                    indicator.stopAnimating()
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
            indicator.stopAnimating()
        }
    
    
    
    
    

    @IBAction func uploadButton(_ sender: Any) {
        
        if (segment.selectedSegmentIndex == -1 || posterName.text == "" || location.text == "" || amount.text == "" || uploadDesc.text == "" || mobileNumber.text == "")
        {
            
            let alert = UIAlertController(title: "Invalid Details", message: "Please enter all the details and try again! ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        else {
            
            startIndicator()
            if(segment.selectedSegmentIndex == 0)
            {
                uploadTitle = "Job"
            }
            else if(segment.selectedSegmentIndex == 1) {
                uploadTitle = "Rental"
            }
            
            var ref: DocumentReference? = nil
            ref = self.db.collection("Upload").addDocument(data: [
                "Poster-Name": self.posterName.text!,
                "Title": self.uploadTitle,
                "Location": self.location.text!,
                "Amount" : self.amount.text!,
                "Description" : self.uploadDesc.text!,
                "Mobile-Number" : self.mobileNumber.text!,
                "User" : "\(Auth.auth().currentUser!.uid)"
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    self.uploadImage(self.imageView.image!, refId: ref!.documentID)
                    self.db.collection("Upload").document(ref!.documentID).setData(["Ref" : ref!.documentID], merge: true)
                    print("Document added with ID: \(ref!.documentID)")
                    
                }
            }
        }
        
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
                    
                    // Fire base Code goes here
                    
                    self.db.collection("Upload").document(refId).setData(["Image" : "\(url!)"], merge: true)
                    self.indicator.stopAnimating()
                    let alert = UIAlertController(title: "Upload Sucessfull", message:nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                        _ = self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func startIndicator(){
        self.indicator.center = self.view.center
        self.indicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            self.indicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }
}
