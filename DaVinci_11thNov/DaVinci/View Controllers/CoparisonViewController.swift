//
//  CoparisonViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/3/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CoparisonViewController: BaseViewController ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var leftStyle: UILabel!
    @IBOutlet weak var rightStyle: UILabel!

    @IBOutlet weak var collectionViewLeft: UICollectionView!
    
    @IBOutlet weak var collectionViewRight: UICollectionView!
    var appDelegate:AppDelegate!
    var order:Orders?
    var orderItems:NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="COMPARE PRODUCTS"

        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let nibLeft = UINib(nibName: "CompCollectionViewCell", bundle: nil)
        self.collectionViewLeft?.register(nibLeft, forCellWithReuseIdentifier: "CompCollectionViewCell")
        self.collectionViewLeft.isPagingEnabled = true;
        
        let nibRight = UINib(nibName: "CompRightCollectionViewCell", bundle: nil)
        self.collectionViewRight?.register(nibRight, forCellWithReuseIdentifier: "CompRightCollectionViewCell")
        self.collectionViewRight.isPagingEnabled = true;
        
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if(self.appDelegate.getCurrentOrderId() != nil){
            
            order = DataManager.GetCurrentOrderForOrderId(self.appDelegate.getCurrentOrderId()!)
            orderItems = DataManager.GetAllOrderItemsForOrderId((order?.id)!)
           
            
        }else{
            orderItems = NSArray()
            
            
        }
        
        let layout:UICollectionViewFlowLayout  = self.collectionViewLeft.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.collectionViewLeft.frame.size.width, height: self.collectionViewLeft.bounds.size.height)
        layout.scrollDirection = .horizontal
        
        let layout1:UICollectionViewFlowLayout  = self.collectionViewRight.collectionViewLayout as!  UICollectionViewFlowLayout
        layout1.itemSize = CGSize(width: self.collectionViewRight.frame.size.width, height: self.collectionViewRight.bounds.size.height)
        layout1.scrollDirection = .horizontal
        
        self.scrollViewDidEndDecelerating(self.collectionViewRight)
        self.scrollViewDidEndDecelerating(self.collectionViewLeft)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override var shouldAutorotate : Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
            return true
        }
        else {
            return false
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft ,UIInterfaceOrientationMask.landscapeRight]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (orderItems?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionViewRight){
            //CompRightCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompRightCollectionViewCell", for: indexPath) as! CompRightCollectionViewCell
//            cell.productImage.image = UIImage(named: "dummy");
            let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
            let product:Products = DataManager.GetProductForProductId((orderItem.product_id)!)!
            
            let image:String = DataManager.GetImageFromImageUrl((product.primary_image)!)!
            loadImageFromUrl(image, view: cell.productImage)
            cell.productImage.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionViewRight.bounds.size.height)
            cell.productImage.contentMode = .scaleAspectFit
            return cell

        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompCollectionViewCell", for: indexPath) as! CompCollectionViewCell
//            cell.productImage.image = UIImage(named: "dummy");
            let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
            let product:Products = DataManager.GetProductForProductId((orderItem.product_id)!)!
            
            let image:String = DataManager.GetImageFromImageUrl((product.primary_image)!)!
            loadImageFromUrl(image, view: cell.productImage)
            cell.productImage.frame = CGRect(x: 0, y: 0, width: (collectionView.frame.size.width), height: collectionViewRight.bounds.size.height)
            cell.productImage.contentMode = .scaleAspectFit

            return cell

            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if(collectionView == self.collectionViewLeft){
//            return CGSize(width: 510, height: 704)
//
//        }else if(collectionView == self.collectionViewRight){
//            return CGSize(width: 510, height: 704)
//            
//        }
        return CGSize(width: collectionView.frame.size.width, height: self.collectionViewRight.bounds.size.height)
    }
    
    override func loadImageFromUrl(_ urlFile: String, view: UIImageView){
        let filename = self.getDocumentsDirectory().appendingPathComponent("\(urlFile)")
        // Create Url from string
        let url = URL(fileURLWithPath: filename)
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                    view.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width/2), height: self.collectionViewRight.bounds.size.height)
                })
            }
        }) 
        
        // Run task
        task.resume()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        let curretntPage = Int (pageNumber)
        
        
        if self.orderItems?.count>curretntPage {
            if(scrollView == self.collectionViewLeft){
                let orderItem:Order_items = orderItems![curretntPage] as! Order_items
                let product:Products = DataManager.GetProductForProductId((orderItem.product_id)!)!
                self.leftStyle.text = "Style: \((product.style)!)"
                self.leftStyle.adjustsFontSizeToFitWidth = true
            }else{
                let orderItem:Order_items = orderItems![curretntPage] as! Order_items
                let product:Products = DataManager.GetProductForProductId((orderItem.product_id)!)!
                self.rightStyle.text = "Style: \((product.style)!)"
                self.rightStyle.adjustsFontSizeToFitWidth = true
            }
        }
        
        
    }


}
