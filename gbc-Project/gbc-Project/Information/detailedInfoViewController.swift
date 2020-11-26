//
//  detailedInfoViewController.swift
//  gbc-Project
//
//  Created by Rahul's Mac on 2020-11-17.
//

import UIKit

class detailedInfoViewController: UIViewController {
    var info:String = ""
    @IBOutlet weak var detailTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.text = info
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
}
