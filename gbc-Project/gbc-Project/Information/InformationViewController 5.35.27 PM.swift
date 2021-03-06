//
//  InformationViewController.swift
//  gbc-Project z 
//
//  Created by Rahul's Mac on 2020-10-15.
//

import UIKit
import SafariServices
import Firebase

class InformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //DATA ARRAY
    var webArray = ["For Checklist before travel","For information on Covid","For information on Cerb","Important information for students","Ontario Colleges"]
    var tipArray = ["Never share your sin number","Always Quarantine when you arrive","Never take off your mask in public","Collect your work/study permit at the Airport","Submit your ArriveCan form before hand"]
    var rowSelected = 0
    var infoImage: UIImage?
    var webLinks = ["https://moving2canada.com/essential-list/","https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19.html","https://www.canada.ca/en/services/benefits/ei/cerb-application.html","https://www.alleducationschools.com/about/important-info/","https://www.ontario.ca/page/study-ontario-international-students"]
    var detailInfo = ""
    var detailTitle = ""
    var webURL: String = ""
    var db = Firestore.firestore()
    var infoArray:[Info] = [Info]()
    
    //OUTLETS
    @IBOutlet weak var webTableView: UITableView!
    @IBOutlet weak var adminInfoTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webTableView.delegate = self
        webTableView.dataSource = self
        adminInfoTableView.delegate = self
        adminInfoTableView.dataSource = self
        
        self.adminInfoTableView.rowHeight = 200
        loadData()
    }
    
    @IBAction func tipButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Tip of the Day", message: tipArray.randomElement(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.webTableView{
            return webArray.count
        }
        else {
           return infoArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.webTableView{
        let cell:UITableViewCell = (webTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
                cell.textLabel?.text = webArray[indexPath.row]
            return cell
        }
        
        else{
              let cell:InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customInfoCell") as! InfoTableViewCell
            
               cell.infoTextView.text = infoArray[indexPath.row].title
               cell.titleTextField.text =  infoArray[indexPath.row].Info
               cell.infoTextView.isEditable = false
               UIImage.loadFrom(url: URL(string: infoArray[indexPath.row].UImage)!) { i in
                  cell.infoImageView.image = i
                  self.infoImage = i
                
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.webTableView{

        rowSelected = indexPath.row
        print(webArray[rowSelected])
        let vc = SFSafariViewController(url: URL(string: "\(webLinks[rowSelected])")!)
        present(vc,animated: true)
    }
        else{
            print("hello \(detailInfo)")
            detailInfo = infoArray[indexPath.row].Info
            detailTitle = infoArray[indexPath.row].title
           // infoImage = infoArray[indexPath.row].UImage
          //  print("image path :\(infoImage)")
            

            self.performSegue(withIdentifier: "detailedInfoSegue", sender: self)

        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pNumber = segue.destination as! detailedInfoViewController
        pNumber.info = self.detailTitle
        pNumber.title = self.detailInfo
        pNumber.selectedImage = self.infoImage
    }
    
    func loadData() {
        db.collection("infoUpload").getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        self.infoArray = [Info]()
                        if let snapshot = snapshot {

                            for document in snapshot.documents {

                                let data = document.data()
                                let info = data["Title-Info"] as? String ?? ""
                                let title = data["Description"] as? String ?? ""
                                let uImage = data["Image"] as? String ?? ""
                                let i:Info = Info(Info: info, title: title, UImage: uImage)
                               
                                self.infoArray.append(i)
                                print(self.infoArray)
                            }
                            self.adminInfoTableView.reloadData()
                        }
                    }
        }}}
    
