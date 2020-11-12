//
//  UpdatePostingsViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-11-07.
//

import UIKit
import Firebase

class UpdatePostingsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var pName: UITextField!
    @IBOutlet weak var pLocation: UITextField!
    @IBOutlet weak var pAmount: UITextField!
    @IBOutlet weak var pNumber: UITextField!
    @IBOutlet weak var pDesc: UITextField!
    
    var DocPath:String = ""
    var Array:[Upload] = [Upload]()
    
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFireBaseData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateButton(_ sender: Any) {
        
        
        
        
        
        
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        
        
        
        
        
        
        
        
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
                                        self.segmentControl.selectedSegmentIndex == 0
                                        
                                    }
                                    else{
                                        self.segmentControl.selectedSegmentIndex == 1
                                    }
                                    
                                }
                            }
                        }
                    }
                }
    }
    
    
    
}
