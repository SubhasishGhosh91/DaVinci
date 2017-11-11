//
//  CollectionViewCell.swift
//  DaVinci
//
//  Created by Avik Roy on 6/19/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelProductNamePrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
