//
//  SlideShowViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/4/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
import AVKit
import  AVFoundation
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class SlideShowViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UITextFieldDelegate {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblFabric: UILabel!
    @IBOutlet weak var lblStyle: UILabel!
    @IBOutlet weak var textIntroduction: UILabel!
    @IBOutlet weak var playVideoButton: UIButton!
    
    @IBOutlet weak var labelPageIndex: UITextField!
    @IBOutlet var cartButton: UIButton!
    @IBOutlet weak var ssCollectionView: UICollectionView!
    var productListingController:PopOverProductViewController!
    var detailPopover: UIPopoverPresentationController!
    var selectedProduct:Products?
    let identifier = "SSCollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var appDelegate:AppDelegate?
    var allSliders : NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="SLIDESHOW"
        let barButton = UIBarButtonItem(customView: self.cartButton)
        self.navigationItem.rightBarButtonItem = barButton
        self.labelPageIndex.delegate = self
        let nib = UINib(nibName: "SSCollectionViewCell", bundle: nil)
        self.ssCollectionView?.register(nib, forCellWithReuseIdentifier: "SSCollectionViewCell")
        self.ssCollectionView.isPagingEnabled = true;
        
        
        self.productListingController = PopOverProductViewController(nibName: "PopOverProductViewController", bundle: nil)
        self.productListingController.completionHandler = {
            (selectedProduct : Products) -> Void in
            self.productListingController.dismiss(animated: true, completion: nil)
            
            let controller:ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            controller.selectedProduct = selectedProduct
            
            self.navigationController?.pushViewController(controller, animated: true)
            
            //            let controller:PichandZoomImageViewControlelrViewController = PichandZoomImageViewControlelrViewController(nibName: "PichandZoomImageViewControlelrViewController", bundle: nil)
            //            controller.product = selectedProduct
            //            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        self.allSliders = DataManager.GetAllSlidersForCollectionId(appDelegate!.selectedCollection!.id!)
        self.labelPageIndex.text = "\(1)"
        if self.allSliders?.count>0 {
            
            let slider:Slider = self.allSliders![0] as! Slider
            self.selectedProduct =  DataManager.GetProductForSliderId(slider.product_id!)!
            self.textIntroduction   .text = "\((self.selectedProduct?.style)!)"

            if(self.selectedProduct!.video == nil){
                self.playVideoButton.isHidden = true
            }else{
                self.playVideoButton.isHidden = false
                
            }
            
            
            
            
            var colorString:String = "Color: "
            let colorArray = DataManager.GetColorsForSelectedProducts(selectedProduct!)
            if colorArray.count > 0 {
                for index in 0...colorArray.count-1{
                    let color :Color_manage = colorArray[index] as! Color_manage
                    colorString = colorString + "\((color.color)!)"
                    if(index != colorArray.count-1){
                        colorString = colorString + ", "
                    }
                }
            }
            
            
           
        }
        
        let layout:UICollectionViewFlowLayout  = self.ssCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.size.width /*- 38*/
        let height = UIScreen.main.bounds.size.height - 206
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isNumber() == true) {
            let index = Int(textField.text!)
            if index <= self.allSliders?.count && index > 0{
                let indexPath : IndexPath = IndexPath(item: index!-1, section: 0)
                self.ssCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                
                let curretntPage:NSInteger = index!-1
                
                if self.allSliders?.count>curretntPage {
                    let slider:Slider = self.allSliders![curretntPage] as! Slider
                    if(DataManager.GetProductForSliderId(slider.product_id!) != nil){
                        self.selectedProduct =  DataManager.GetProductForSliderId(slider.product_id!)!
                        if(self.selectedProduct!.video == nil){
                            self.playVideoButton.isHidden = true
                        }else{
                            self.playVideoButton.isHidden = false
                            let image:String = DataManager.GetImageFromImageUrl((selectedProduct!.video)!)!
                            let filename = self.getDocumentsDirectory().appendingPathComponent("\(image)")
                            let fileManager = FileManager.default
                            if fileManager.fileExists(atPath: filename){
                                self.playVideoButton.isHidden = false
                                
                            } else {
                                self.playVideoButton.isHidden = true
                                
                            }
                            
                        }
                       
//                        self.textIntroduction   .text = "\(appDelegate!.selectedCollection!.name!)"

                        
                        var colorString:String = "Color: "
                        let colorArray = DataManager.GetColorsForSelectedProducts(selectedProduct!)
                        if(colorArray.count > 0) {
                            for index in 0...colorArray.count-1{
                                let color :Color_manage = colorArray[index] as! Color_manage
                                colorString = colorString + "\((color.color)!)"
                                if(index != colorArray.count-1){
                                    colorString = colorString + ", "
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                self.labelPageIndex.text = "\(curretntPage+1)"
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.appDelegate!.getCurrentOrderId() != nil){
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)
            
            
            self.cartButton.setTitle("\(totalCount)", for: UIControlState());
            self.cartButton.setTitle("\(totalCount)", for: UIControlState.highlighted);
            
        }else{
            
            self.cartButton.setTitle("0", for: UIControlState());
            self.cartButton.setTitle("0", for: UIControlState.highlighted);
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func cartClickAction(_ sender: AnyObject) {
        let controller:OrderViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true);
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.allSliders?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SSCollectionViewCell", for: indexPath) as! SSCollectionViewCell
        //        cell.cellImage.image = UIImage(named: "dummy");
        let slider:Slider = self.allSliders![indexPath.item] as! Slider
        
        
        if DataManager.GetProductForSliderId(slider.product_id!) != nil{
            let product : Products =  DataManager.GetProductForSliderId(slider.product_id!)!
            if(product.video == nil){
                cell.playButton.isHidden = true
            }else{
                cell.playButton.isHidden = true
            }
            cell.cellView.isUserInteractionEnabled = true
            cell.cellView.bringSubview(toFront: cell.playButton)
            //        cell.playButton.backgroundColor = UIColor.cyanColor()
            cell.playButton.addTarget(self, action: #selector(SlideShowViewController.btnVideoAction(_:)), for: UIControlEvents.touchUpInside)
            //        cell.cellImage.backgroundColor = UIColor.redColor()
            //        cell.cellView.backgroundColor = UIColor.yellowColor()
            let imagePath:String = DataManager.GetImageFromImageUrl((product.primary_image)!)!
            loadImageFromUrl(imagePath, view: cell.cellImage,indexPath: indexPath)
            cell.cellImage.contentMode = UIViewContentMode.scaleAspectFit
            //        cell.layer.borderWidth = 1.0;
            //        cell.layer .borderColor = UIColor.redColor().CGColor
            let width = UIScreen.main.bounds.size.width - 38
            let height = UIScreen.main.bounds.size.height - 206
            cell.cellImage.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }else{
            cell.playButton.isHidden = true
            cell.cellView.isUserInteractionEnabled = false
            cell.cellView.bringSubview(toFront: cell.playButton)
            cell.cellImage.image = UIImage(named: "")
            let width = UIScreen.main.bounds.size.width - 38
            let height = UIScreen.main.bounds.size.height - 206
            cell.cellImage.frame = CGRect(x: 0, y: 0, width: width, height: height)

        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/*- 38*/
        let height = UIScreen.main.bounds.size.height - 206
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.selectedProduct?.is_sellable == true && self.selectedProduct?.primary_image != nil){
            let controller:PichandZoomImageViewControlelrViewController = PichandZoomImageViewControlelrViewController(nibName: "PichandZoomImageViewControlelrViewController", bundle: nil)
            controller.product = self.selectedProduct
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func btnVideoAction(_ sender:UIButton)
    {
        let pageNumber = round(self.ssCollectionView.contentOffset.x / self.ssCollectionView.frame.size.width)
        let curretntPage = Int (pageNumber)
        
        let slider:Slider = self.allSliders![curretntPage] as! Slider
        let product : Products =  DataManager.GetProductForSliderId(slider.product_id!)!
        let image:String = DataManager.GetImageFromImageUrl((product.video)!)!
        let filename = self.getDocumentsDirectory().appendingPathComponent("\(image)")
        let videoURL = URL(fileURLWithPath: filename)
        //        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func playVideoAction(_ sender: AnyObject) {
        let curretntPage:NSInteger = (NSInteger) (self.ssCollectionView.contentOffset.x/self.ssCollectionView.frame.size.width)
        
        let slider:Slider = self.allSliders![curretntPage] as! Slider
        let product : Products =  DataManager.GetProductForSliderId(slider.product_id!)!
        let image:String = DataManager.GetImageFromImageUrl((product.video)!)!
        let filename = self.getDocumentsDirectory().appendingPathComponent("\(image)")
        let videoURL = URL(fileURLWithPath: filename)
        //        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
    func loadImageFromUrl(_ urlFile: String, view: UIImageView, indexPath: IndexPath){
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
                    view.contentMode = .scaleAspectFit
//                    let cell :SSCollectionViewCell = self.ssCollectionView.cellForItemAtIndexPath(indexPath) as! SSCollectionViewCell
                    let width = UIScreen.main.bounds.size.width - 38
                    let height = UIScreen.main.bounds.size.height - 206
                    view.frame = CGRect(x: 0, y: 0, width: width, height: height)
//                    self.ssCollectionView.reloadItemsAtIndexPaths([indexPath])
                })
            }
        }) 
        
        // Run task
        task.resume()
    }
    
    @IBAction func addAction(_ sender: AnyObject) {
        if(self.selectedProduct?.is_sellable == true){
            //            let controller:ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            //            controller.selectedProduct = self.selectedProduct
            //            self.navigationController?.pushViewController(controller, animated: true)
            
            if(self.appDelegate!.getCurrentOrderId() == nil){
                let timeInterval = Date().timeIntervalSince1970
                
                if(appDelegate?.selectedStore != nil){
                    
                    var orderid:String = "\((self.appDelegate!.getCurrentSalesmanId())!)\(timeInterval)"
                    orderid = orderid.replacingOccurrences(of: " ", with: "_")
                    orderid = orderid.replacingOccurrences(of: "+", with: "_")
                    orderid = orderid.replacingOccurrences(of: ".", with: "")
                    
                    self.appDelegate!.setCurrentOrderId(orderid)
                    
                }else{
                    var orderid:String = "\((self.appDelegate!.getCurrentSalesmanId())!)\(timeInterval)"
                    orderid = orderid.replacingOccurrences(of: " ", with: "_")
                    orderid = orderid.replacingOccurrences(of: "+", with: "_")
                    orderid = orderid.replacingOccurrences(of: ".", with: "")
                    
                    self.appDelegate!.setCurrentOrderId(orderid)
                    
                }
                let orders:Orders? = DataManager.initializeSize_orders()
                orders!.id = "\(self.appDelegate!.getCurrentOrderId()!)"
                orders!.order_id = (self.appDelegate!.getCurrentOrderId())!
                orders!.salesman_id = self.appDelegate!.getCurrentSalesmanId()
                orders!.ship_to = ""
                orders!.bill_to = ""
                orders!.catelouge = ""
//                orders!.order_date = NSDate ()
//                orders!.start_date = NSDate ()
//                orders!.complition_date = NSDate ()
                orders!.order_note = ""
                orders!.signature = ""
                orders!.order_submitted = NSNumber(value: false as Bool)
                orders!.order_editable    = NSNumber(value: false as Bool)
                if(appDelegate?.selectedStore != nil){
                    orders!.store_id = appDelegate?.selectedStore?.id

                }else{
                    orders!.store_id = "0"

                }
                orders!.created_on = Date()
                DataManager.SaveOrders(orders!)
                
            }
            
            let orderItems:Order_items = DataManager.initializeSize_order_items()
            orderItems.id = "\(Date ())"
            orderItems.order_id = self.appDelegate!.getCurrentOrderId()
            orderItems.product_id = (self.selectedProduct?.id?.stringValue)!
            orderItems.color = ""
            orderItems.size = ""
            orderItems.quantity = ""
            orderItems.quantity = "1"
            let total = self.selectedProduct!.price!.floatValue
            orderItems.price = NSNumber(value: total as Float)
            orderItems.style = (self.selectedProduct?.style)!
            orderItems.note = ""
            orderItems.unit_price = self.selectedProduct?.price
            DataManager.SaveOrderItems(orderItems)
            
            if(self.appDelegate!.getCurrentOrderId() != nil){
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    let orderItems:NSArray = DataManager.GetAllOrderItemsForOrderId(self.appDelegate!.getCurrentOrderId()! )
                    var total = 0
                    for item in orderItems{
                        let order_item : Order_items = item as! Order_items
                        if let number = Int("\((order_item.quantity)!)") {
                            total = total+number
                            
                        }
                        
                    }
                    self.cartButton.setTitle("\(total)", for: UIControlState());
                    self.cartButton.setTitle("\(total)", for: UIControlState.highlighted);
                    
                    
                    
                })
            }
            
        }
        
    }
    
    @IBAction func infoButtonAction(_ sender: AnyObject) {
        //        let contentViewController = UINib(nibName: "PopOverProductViewController", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PopOverProductViewController
        
        self.productListingController.modalPresentationStyle = UIModalPresentationStyle.popover
        self.detailPopover = self.productListingController.popoverPresentationController!
        
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        
        var expected:CGSize!
        
        expected = CGSize(width: width-100,height: height-100)
        
        
        self.productListingController.preferredContentSize   = expected
        
        
        self.detailPopover.sourceRect = CGRect(x: 200, y: 400, width: 370, height: 300);
        self.detailPopover.sourceView = self.view
        self.detailPopover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        present(self.productListingController,
                              animated: true, completion:nil)
        
        self.productListingController.dismissButton.addTarget(self, action: #selector(SlideShowViewController.btnDismissClicked(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override var shouldAutorotate : Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
            return false
        }
        else {
            return true
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    
    func btnDismissClicked(_ sender : AnyObject){
        self.productListingController.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(self.ssCollectionView.contentOffset.x / self.ssCollectionView.frame.size.width)
        let curretntPage = Int (pageNumber)

        
        if self.allSliders?.count>curretntPage {
            let slider:Slider = self.allSliders![curretntPage] as! Slider
            if(DataManager.GetProductForSliderId(slider.product_id!) != nil){
                self.selectedProduct =  DataManager.GetProductForSliderId(slider.product_id!)!
                self.textIntroduction   .text = "\((selectedProduct!.style)!)"
                
                if(self.selectedProduct!.video == nil){
                    self.playVideoButton.isHidden = true
                }else{
                    self.playVideoButton.isHidden = false
                    let image:String = DataManager.GetImageFromImageUrl((selectedProduct!.video)!)!
                    let filename = self.getDocumentsDirectory().appendingPathComponent("\(image)")
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: filename){
                        self.playVideoButton.isHidden = false
                        
                    } else {
                        self.playVideoButton.isHidden = true
                        
                    }
                }
                
                
                
                var colorString:String = "Color: "
                let colorArray = DataManager.GetColorsForSelectedProducts(selectedProduct!)
                if(colorArray.count > 0) {
                    for index in 0...colorArray.count-1{
                        let color :Color_manage = colorArray[index] as! Color_manage
                        colorString = colorString + "\((color.color)!)"
                        if(index != colorArray.count-1){
                            colorString = colorString + ", "
                        }
                    }
                    
                }
                
                
                
                
                
            }
        }
            
        
        self.labelPageIndex.text = "\(curretntPage+1)"
        
    }
    
}

public extension String {
    
    func isNumber() -> Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
}



