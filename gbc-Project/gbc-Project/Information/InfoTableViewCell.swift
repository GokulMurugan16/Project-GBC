//
//  InfoTableViewCell.swift
//  gbc-Project
//
//  Created by Rahul's Mac on 2020-10-29.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      let newText = (infoTextView.text as NSString).replacingCharacters(in: range, with: text)
      return newText.count <= 25
    }
}
