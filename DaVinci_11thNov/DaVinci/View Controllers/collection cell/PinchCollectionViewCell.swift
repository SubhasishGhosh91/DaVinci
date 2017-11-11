//
//  PinchCollectionViewCell.swift
//  DaVinci
//
//  Created by Avik Roy on 7/6/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class PinchCollectionViewCell: UICollectionViewCell ,UIScrollViewDelegate {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblFabric: UILabel!
    @IBOutlet weak var lblStyle: UILabel!
    @IBOutlet weak var pinchScrollView: UIScrollView!
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pinchScrollView.minimumZoomScale = 1.0
        self.pinchScrollView.maximumZoomScale = 6.0
        self.pinchScrollView.delegate = self;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return self.cellImage
    }

}
