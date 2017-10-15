//
//  PassbookTableViewCell.swift
//  Rubit
//
//  Created by Saransh Mittal on 10/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class PassbookTableViewCell: UITableViewCell {

    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var dateOfTransaction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewButton.layer.cornerRadius = 12.0
        viewButton.layer.borderWidth = 1.0
        viewButton.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
