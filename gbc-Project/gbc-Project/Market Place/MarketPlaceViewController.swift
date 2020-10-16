//
//  MarketPlaceViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-15.
//

import UIKit
import Firebase

class MarketPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db = Firestore.firestore()

    @IBOutlet weak var keyWord: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var postingArray:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "marketplace.jpg")!)
        
        self.tableView.rowHeight = 150
        
        loadFireBaseData()
    }
    

    @IBAction func keyWordSearchButton(_ sender: Any) {
        
        print("Button tapped")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return postingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewCell
        cell.posterName?.text = "Hello"
        cell.salary.text = "1"
        cell.location.text = "w"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You have selected cell at index \(indexPath)")
    }

    func loadFireBaseData() {
        db.collection("Upload").getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {

                            for document in snapshot.documents {

                                let data = document.data()
                                let pName = data["Poster-Name"] as? String ?? ""
                                let amount = data["Amount"] as? String ?? ""
                                let loc = data["Location"] as? String ?? ""
                                let posting = ["name": pName, "amount": amount, "location": loc]
                                self.postingArray.append(posting)
                                print(self.postingArray)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
    }
    
}
