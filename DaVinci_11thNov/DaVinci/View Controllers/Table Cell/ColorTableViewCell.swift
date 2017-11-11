//
//  ColorTableViewCell.swift
//  DaVinci
//
//  Created by Avik Roy on 7/5/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
