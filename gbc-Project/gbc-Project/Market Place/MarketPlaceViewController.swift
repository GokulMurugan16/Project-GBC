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


    @IBOutlet weak var filterSegment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var postingArray:[Upload] = [Upload]()
    var uploadArray:[Upload] = [Upload]()
    var i:Int = 0
    
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
        
        if filterSegment.selectedSegmentIndex == 0
        {
            postingArray = [Upload]()
            postingArray = filterArray(name: "Job")
            self.tableView.reloadData()
        }
        else if filterSegment.selectedSegmentIndex == 1
        {
            postingArray = [Upload]()
            postingArray = filterArray(name: "Rental")
            self.tableView.reloadData()
        }
        else
        {
            postingArray = [Upload]()
            postingArray = uploadArray
            self.tableView.reloadData()
        }
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
        
        performSegue(withIdentifier: "detailView", sender: self)
        self.i = indexPath.row
    }

    func loadFireBaseData() {
        db.collection("Upload").getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        self.uploadArray = [Upload]()
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
                                let u:Upload = Upload(amount: amount, loc: loc, title: title, pName: pName, desc: desc,Uimage: uImage, mNumber: mobNum)
                                self.uploadArray.append(u)
                                print(self.postingArray)
                            }
                            self.postingArray = self.uploadArray
                            self.tableView.reloadData()
                        }
                    }
                }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            
            let vc = segue.destination as! DetailViewController
            vc.array = postingArray
            vc.index = i
            
        }
    }
    
    
    func filterArray(name:String) -> [Upload]{
        var array:[Upload] = [Upload]()
        for a in self.uploadArray{
            if a.title == name{
                array.append(a)
            }
        }
        return array
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
