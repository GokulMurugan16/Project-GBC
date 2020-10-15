//
//  MarketPlaceViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-15.
//

import UIKit

class MarketPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var keyWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "marketplace.jpg")!)
        
    }
    

    @IBAction func keyWordSearchButton(_ sender: Any) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }

}
