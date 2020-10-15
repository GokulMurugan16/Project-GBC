//
//  InformationViewController.swift
//  gbc-Project
//
//  Created by Rahul's Mac on 2020-10-15.
//

import UIKit
import SafariServices

class InformationViewController: UIViewController {
    var webURL: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func webViewButton(_ sender: UIButton) {
        if sender.tag == 0{
            webURL = "https://www.canada.ca/en/services/immigration-citizenship.html"
            urlLoader(infoUrl: webURL)
        }
        else if sender.tag == 1{
            webURL = "https://www.ontariocolleges.ca/en"
            urlLoader(infoUrl: webURL)
        }
        else if sender.tag == 2{
            webURL = "https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19.html"
            urlLoader(infoUrl: webURL)
        }
        else if sender.tag == 3{
            webURL = "https://www.cicnews.com/2020/04/how-canada-is-helping-international-students-0414222.html#gs.iqosjf"
            urlLoader(infoUrl: webURL)
        }
        
       
        
    }
    
    
    func urlLoader(infoUrl: String){
        
        let vc = SFSafariViewController(url: URL(string: infoUrl)!)
          present(vc,animated: true)
    }
    
//    let vc = SFSafariViewController(url: URL(string: "https://www.canada.ca/en/services/immigration-citizenship.html")!)
//      present(vc,animated: true)
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
