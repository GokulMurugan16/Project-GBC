//
//  detailedInfoViewController.swift
//  gbc-Project
//
//  Created by Rahul's Mac on 2020-11-17.
//

import UIKit

class detailedInfoViewController: UIViewController {
    
    var info:String = ""
    var titleToDisplay:String = ""
    var selectedImage:String?
    
    
    @IBOutlet weak var titletodisp: UILabel!
    @IBOutlet weak var imageToDisp: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.text = info
        titletodisp.text = titleToDisplay
        UIImage.loadFrom(url: URL(string: selectedImage!)!) { i in
            self.imageToDisp.image = i
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
}
