//
//  ManagePostingsViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-11-06.
//

import UIKit
import Firebase

class ManagePostingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var manageTableView: UITableView!
    let currentUser = Auth.auth().currentUser!.uid
    var db = Firestore.firestore()
    var manaageArray:[Upload] = [Upload]()
    var documentID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Postings"
        manageTableView.rowHeight = 125
        loadFireBaseData()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadFireBaseData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manaageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mCell = tableView.dequeueReusableCell(withIdentifier: "manageCell") as! ManageTableViewCell
        mCell.manageTitle.text = manaageArray[indexPath.row].title
        UIImage.loadFrom(url: URL(string: manaageArray[indexPath.row].Uimage)!) { i in
            mCell.manageImageView.image = i
        }
        
        if(manaageArray[indexPath.row].title == "Job")
        {
            mCell.manageSalary.text = "Salary : \(manaageArray[indexPath.row].amount) $/hr"
        }
        else{
            mCell.manageSalary.text = "Salary : \(manaageArray[indexPath.row].amount) $/month"
        }
        mCell.manageLocation.text = "Location : \(manaageArray[indexPath.row].loc)"
        mCell.layer.borderColor = UIColor.systemGray.cgColor
        mCell.layer.borderWidth = 0.5
        mCell.layer.cornerRadius = 8
       return mCell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.documentID = manaageArray[indexPath.row].refNo
        performSegue(withIdentifier: "manageDetails", sender: self)
    }
    
    
    
    
    
    func loadFireBaseData() {
        self.db.collection("Upload").getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        self.manaageArray = [Upload]()
                        if let snapshot = snapshot {

                            for document in snapshot.documents {

                                let data = document.data()
                                let pName = data["Poster-Name"] as? String ?? ""
                                let amount = data["Amount"] as? String ?? ""
                                let loc = data["Location"] as? String ?? ""
                                let title = data["Title"] as? String ?? ""
                                let desc = data["Description"] as? String ?? ""
                                let uImage = data["Image"] as? String ?? ""
                                let mobNum = data["Mobile-Number"] as? String ?? ""
                                let user = data["User"] as? String ?? ""
                                let refNo = data["Ref"] as? String ?? ""
                                let u:Upload = Upload(amount: amount, loc: loc, title: title, pName: pName, desc: desc,Uimage: uImage, mNumber: mobNum, user: user, refNo: refNo)
                                if(self.currentUser == user)
                                {
                                    self.manaageArray.append(u)
                                }
                            }
                            
                            self.manageTableView.reloadData()
                            print(self.manaageArray)
                            
                        }
                    }
                }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "manageDetails")
        {
        let vc = segue.destination as! UpdatePostingsViewController
        vc.DocPath = self.documentID
        }
    }

}
