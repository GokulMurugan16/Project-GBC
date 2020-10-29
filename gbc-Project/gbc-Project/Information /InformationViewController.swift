//
//  InformationViewController.swift
//  gbc-Project z 
//
//  Created by Rahul's Mac on 2020-10-15.
//

import UIKit
import SafariServices

class InformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var webArray = ["College","Covid","Cerb"]
    var rowSelected = 0
    var webLinks = ["https://www.ontariocolleges.ca/en/colleges","https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19.html","https://www.canada.ca/en/services/benefits/ei/cerb-application.html"]
    
    @IBOutlet weak var webTableView: UITableView!
    
    @IBOutlet weak var adminInfoTableView: UITableView!
    var webURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webTableView.delegate = self
        webTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        webArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (webTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
                cell.textLabel?.text = webArray[indexPath.row]
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected = indexPath.row
        print(webArray[rowSelected])
        let vc = SFSafariViewController(url: URL(string: "\(webLinks[rowSelected])")!)
        present(vc,animated: true)
    }
   

}
