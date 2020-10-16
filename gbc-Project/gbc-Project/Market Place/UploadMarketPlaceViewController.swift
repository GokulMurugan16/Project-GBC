//
//  UploadMarketPlaceViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-15.
//

import UIKit
import Firebase

class UploadMarketPlaceViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var posterName: UITextField!
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    
    @IBOutlet weak var uploadDesc: UITextField!
    
    var uploadTitle:String = "Job"
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func uploadButton(_ sender: Any) {
        
        if (segment.selectedSegmentIndex == -1 || posterName.text == "" || location.text == "" || amount.text == "" )
        {
            
            var alert = UIAlertController(title: "Invalid Details", message: "Please enter all the details and try again! ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        else {
            
            
            if(segment.selectedSegmentIndex == 0)
            {
                title = "Job"
            }
            else {
                title = "Rental"
            }
            
            var ref: DocumentReference? = nil
            ref = self.db.collection("Upload").addDocument(data: [
                "Poster Name ": self.posterName.text!,
                "Title": self.uploadTitle,
                "Location": self.location.text!,
                "Amount" : self.amount.text!,
                "Description" : self.uploadDesc.text!
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        
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
