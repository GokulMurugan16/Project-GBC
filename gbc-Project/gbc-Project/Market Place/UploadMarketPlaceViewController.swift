//
//  UploadMarketPlaceViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-15.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadMarketPlaceViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var posterName: UITextField!
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    
    @IBOutlet weak var uploadDesc: UITextField!
    
    var uploadTitle:String = ""
    var db = Firestore.firestore()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storage = Storage.storage()
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func uploadButton(_ sender: Any) {
        
        if (segment.selectedSegmentIndex == -1 || posterName.text == "" || location.text == "" || amount.text == "" || uploadDesc.text == "")
        {
            
            var alert = UIAlertController(title: "Invalid Details", message: "Please enter all the details and try again! ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        else {
            
            
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
                "Description" : self.uploadDesc.text!
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    var alert = UIAlertController(title: "Upload Sucessfull", message:nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
        
    }
    
    
    

}
