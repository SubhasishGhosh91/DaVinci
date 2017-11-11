//
//  StoreTableViewCell.swift
//  DaVinci
//
//  Created by Aviru bhattacharjee on 24/09/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblStoreName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
