//
//  CollectionTableViewCell.swift
//  DaVinci
//
//  Created by Avik Roy on 7/9/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
