//
//  OrderTableViewCell.swift
//  DaVinci
//
//  Created by Avik Roy on 7/2/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var textViewAboutProduct: UITextView!
    @IBOutlet weak var productQuantity: UIButton!
    @IBOutlet weak var productSize: UIButton!
    @IBOutlet weak var btnProcutColor: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelStyle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.current.isiPadPro12 {
            btnProcutColor.imageEdgeInsets = UIEdgeInsetsMake(-8, 140, 0, 0);
            productSize.imageEdgeInsets = UIEdgeInsetsMake(-8, 140, 0, 0);
            productQuantity.imageEdgeInsets = UIEdgeInsetsMake(-8, 140, 0, 0);

        }
        

        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

extension UIDevice {
    
    public var isiPadPro12: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
            && (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366) {
            return true
        }
        return false
    }
    
}
