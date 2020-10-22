//
//  TableViewCell.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-15.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var imagePosting: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
