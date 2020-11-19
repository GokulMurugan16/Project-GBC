//
//  ManageTableViewCell.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-11-06.
//

import UIKit

class ManageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var manageImageView: UIImageView!
    @IBOutlet weak var manageTitle: UILabel!
    @IBOutlet weak var manageLocation: UILabel!
    @IBOutlet weak var manageSalary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        manageImageView.layer.cornerRadius = manageImageView.bounds.height/2
        manageImageView.clipsToBounds = true
    }

}
