//
//  DetailViewController.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-28.
//

import UIKit
import Firebase
import MessageUI

class DetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {
   
    var array:[Upload] = [Upload]()
    var index:Int = 0

    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var titleDisplay: UILabel!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var detailsDesc: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageDisplay.layer.cornerRadius = imageDisplay.bounds.height/2
        imageDisplay.clipsToBounds = true
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
    
    @IBAction func smsButton(_ sender: Any) {
            
            let sendVC:MFMessageComposeViewController = MFMessageComposeViewController()
        sendVC.body = "Hi i am \(Auth.auth().currentUser?.displayName!)I would like to know more details about \(titleDisplay.text!) in \(location.text!)"
            sendVC.recipients = ["\(contactNumber.text!)","4372374124"]
            sendVC.messageComposeDelegate = self
            self.present(sendVC, animated: false, completion: nil)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case MessageComposeResult.cancelled:
            print("Working fine but cancelled")
            break
            
        case MessageComposeResult.failed:
            let alert = UIAlertController(title: "Message Failed", message: "Please try again! ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {alert in}))
            self.present(alert, animated: true, completion: nil)
            break
            
        case MessageComposeResult.sent:
            let alert = UIAlertController(title: "Message Sent", message: "Your message sent to recipients successfully ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
            
        default:
            break
        }
        
        self.dismiss(animated: true,completion:nil)
        
        
    }
    
    
    

}
