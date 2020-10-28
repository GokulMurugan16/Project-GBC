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
    
    var postingArray:[Upload] = [Upload]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "marketplace.jpg")!)
        
        self.tableView.rowHeight = 150
        
        loadFireBaseData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        
        cell.jobTitle.text = postingArray[indexPath.row].title
        UIImage.loadFrom(url: URL(string: postingArray[indexPath.row].Uimage)!) { i in
            cell.imagePosting.image = i
        }
        
        if(postingArray[indexPath.row].title == "Job")
        {
        cell.salary.text = "\(postingArray[indexPath.row].amount) $/hr"
        }
        else{
            cell.salary.text = "\(postingArray[indexPath.row].amount) $/month"
        }
        cell.location.text = "Location : \(postingArray[indexPath.row].loc)"
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
                        
                        self.postingArray = [Upload]()
                        if let snapshot = snapshot {

                            for document in snapshot.documents {

                                let data = document.data()
                                let pName = data["Poster-Name"] as? String ?? ""
                                let amount = data["Amount"] as? String ?? ""
                                let loc = data["Location"] as? String ?? ""
                                let title = data["Title"] as? String ?? ""
                                let desc = data["Description"] as? String ?? ""
                                let uImage = data["Image"] as? String ?? ""
                                var u:Upload = Upload(amount: amount, loc: loc, title: title, pName: pName, desc: desc,Uimage: uImage)
                                self.postingArray.append(u)
                                print(self.postingArray)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
    }
    
}


extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
