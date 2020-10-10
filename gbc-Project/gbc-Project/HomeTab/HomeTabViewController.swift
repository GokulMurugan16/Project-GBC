//
//  HomeTabViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-10.
//

import UIKit

class HomeTabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var newsTableViewOutlet: UITableView!
    
    // MARK: - Default Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTableViewOutlet.dataSource = self
        self.newsTableViewOutlet.delegate = self

        // Do any additional setup after loading the view.
    }
    
    // MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    

   
    

}
