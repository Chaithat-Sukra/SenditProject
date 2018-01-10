//
//  ItemTableViewCell.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgvItem: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
