//
//  detailedInfoViewController.swift
//  gbc-Project
//
//  Created by Rahul's Mac on 2020-11-17.
//

import UIKit

class detailedInfoViewController: UIViewController {
    var info:String = ""
    var detail:String = ""
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.text = info
        titleLabel.text = detail
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
}
