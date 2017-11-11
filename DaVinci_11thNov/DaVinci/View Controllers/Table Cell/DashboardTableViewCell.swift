//
//  DashboardTableViewCell.swift
//  DaVinci
//
//  Created by Avik Roy on 6/2/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonSelection: UIButton!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelPO: UILabel!
    @IBOutlet weak var labelCollection: UILabel!
    @IBOutlet weak var labelShop: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
