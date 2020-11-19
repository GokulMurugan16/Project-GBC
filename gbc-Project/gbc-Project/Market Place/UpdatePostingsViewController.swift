//
//  UpdatePostingsViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-11-07.
//

import UIKit
import Firebase

class UpdatePostingsViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var pName: UITextField!
    @IBOutlet weak var pLocation: UITextField!
    @IBOutlet weak var pAmount: UITextField!
    @IBOutlet weak var pNumber: UITextField!
    @IBOutlet weak var pDesc: UITextField!
    
    var DocPath:String = ""
    var Array:[Upload] = [Upload]()
    var titleUpdate:String = ""
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFireBaseData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UpdatePostingsViewController.imageTapped))
        imageView.addGestureRecognizer(tap)
        
        imageView.layer.cornerRadius = imageView.bounds.height/2
        imageView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
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
    
    func uploadImage(_ image:UIImage, refId : String)
    {
        let storageRef = Storage.storage().reference().child("Uploads/\(refId)")

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}


        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {

                storageRef.downloadURL { url, error in
                    self.db.collection("Upload").document(refId).setData(["Image" : "\(url!)"], merge: true)
                    let alert = UIAlertController(title: "Update Successfull", message:nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                        self.performSegue(withIdentifier: "managePostings", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func updateButton(_ sender: Any) {
        
        if (segmentControl.selectedSegmentIndex == -1 || pName.text == "" || pLocation.text == "" || pAmount.text == "" || pDesc.text == "" || pNumber.text == "")
        {
            let alert = UIAlertController(title: "Invalid Details", message: "Please enter all the details and try again! ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            if(segmentControl.selectedSegmentIndex == 0)
            {
                titleUpdate = "Job"
            }
            else if(segmentControl.selectedSegmentIndex == 1) {
                titleUpdate = "Rental"
            }
            db.collection("Upload").document(DocPath).setData([
                "Poster-Name": self.pName.text!,
                "Title": self.titleUpdate,
                "Location": self.pLocation.text!,
                "Amount" : self.pAmount.text!,
                "Description" : self.pDesc.text!,
                "Mobile-Number" : self.pNumber.text!,
            ], merge: true)
            
            uploadImage(imageView.image!, refId: self.DocPath)
            
            let alert = UIAlertController(title: "Update Sucessful", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: {(UIAlertAction) in
                self.performSegue(withIdentifier: "managePostings", sender: self)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete?", message: "This data will be no longer displayed. Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { alert in
            self.db.collection("Upload").document(self.DocPath).delete()
            let alert2 = UIAlertController(title: "Delete Sucessfull", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {a in
                    self.performSegue(withIdentifier: "managePostings", sender: self)
                }))
            self.present(alert2, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadFireBaseData() {
        
        db.collection("Upload").getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {

                            for document in snapshot.documents {
                                
                                let data = document.data()
                                let refNo = data["Ref"] as? String ?? ""
                                
                                if( refNo == self.DocPath){
                                    UIImage.loadFrom(url: URL(string: data["Image" as String] as! String)!) { i in
                                        self.imageView.image = i
                                    }
                                    self.pName.text = data["Poster-Name"] as? String ?? ""
                                    self.pAmount.text = data["Amount"] as? String ?? ""
                                    self.pDesc.text = data["Description"] as? String ?? ""
                                    self.pLocation.text = data["Location"] as? String ?? ""
                                    self.pNumber.text = data["Mobile-Number"] as? String ?? ""
                                    
                                    
                                    let selectedSegmentIndex = data["Title"] as? String ?? ""
                                    if(selectedSegmentIndex == "Job")
                                    {
                                        self.segmentControl.selectedSegmentIndex = 0
                                        
                                        
                                    }
                                    else{
                                        self.segmentControl.selectedSegmentIndex = 1
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                }
    }
    
    
    
}
