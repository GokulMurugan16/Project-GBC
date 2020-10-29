//
//  DetailViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-28.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var array:[Upload] = [Upload]()
    var index:Int = 0

    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var titleDisplay: UILabel!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var detailsDesc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIImage.loadFrom(url: URL(string: array[index].Uimage)!)
        { imageToDisplay in
            self.imageDisplay.image = imageToDisplay
        }
        titleDisplay.text = array[index].title
        posterName.text = array[index].pName
        location.text = array[index].loc
        amount.text = array[index].amount
        detailsDesc.text = array[index].desc
        contactNumber.text = array[index].mNumber
        
        
    }
    


}
