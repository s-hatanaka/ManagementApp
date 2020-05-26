//
//  ConsumeTableViewCell.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/26.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit

class ConsumeTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
