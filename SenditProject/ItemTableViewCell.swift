//
//  ItemTableViewCell.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    var bDidSelect: (Void) -> Void = {_ in }
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgvItem: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbURL: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func favouritePressed(_ sender: Any) {
        bDidSelect()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
