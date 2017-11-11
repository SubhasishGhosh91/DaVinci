//
//  ProductDetailsViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/20/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
import AVKit
import  AVFoundation
//128

class ProductDetailsViewController: BaseViewController, UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblColorValue: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var labelQuantityToAdd: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonQuantity: UIButton!
    @IBOutlet weak var buttonSize: UIButton!
    @IBOutlet weak var buttonColor: UIButton!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelColor: UILabel!
    @IBOutlet weak var labelFabric: UILabel!
    @IBOutlet weak var labelStyle: UILabel!
    @IBOutlet var buttonCart: UIButton!
    var colorPickerHeight:NSInteger!
    var colorController:ColorPickerViewControlelrViewController!
    var colorPopover: UIPopoverPresentationController!
    var sizePickerController:SizePickerViewController!
    var sizePopover:UIPopoverPresentationController!
    var quantityPickerController : QuantityPickerViewController!
    var quantityPopover:UIPopoverPresentationController!
    var selectedProduct : Products?
    var appDelegate:AppDelegate!
    var selectedColor:Color_manage?
    var selectedSize:Size_manage?
    var quantity:NSInteger?
    var quantutyString:String?
    var priceUpc: Pricing_upcharge?
    var imageArray : NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="STYLE \((self.selectedProduct?.style)!)"
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.colorPickerHeight = 128;
        self.view.bringSubview(toFront: self.videoButton);
        if(self.selectedProduct?.video == nil){
            self.videoButton.isHidden = true
        }else{
            self.videoButton.isHidden = false

        }
        
        let nib = UINib(nibName: "SSCollectionViewCell", bundle: nil)
        self.productCollectionView?.register(nib, forCellWithReuseIdentifier: "SSCollectionViewCell")
        self.productCollectionView.isPagingEnabled = true;
        
        self.productCollectionView.delegate  = self;
        self.productCollectionView.dataSource = self;
        //        self.pinchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if self.selectedProduct?.images != nil {
            imageArray  = NSMutableArray(array: (self.selectedProduct!.images?.components(separatedBy: ","))!)
            self.pageControl.currentPage = 0;
        }else{
            imageArray = NSMutableArray()
        }
        
        if self.selectedProduct?.primary_image != nil {
            imageArray?.insert((self.selectedProduct?.primary_image)!, at: 0)
        }
        
        let layout:UICollectionViewFlowLayout  = self.productCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.size.width /*- 38*/
        let height = self.productCollectionView.bounds.size.height
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal

        
        self.productCollectionView.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
       
        self.productCollectionView.reloadData()
        
        
        if(self.appDelegate.getCurrentOrderId() != nil){
        
//            let orderItems:NSArray = DataManager.GetAllOrderItemsForOrderId(self.appDelegate.getCurrentOrderId()! )
//            var total = 0
//            for item in orderItems{
//                let order_item : Order_items = item as! Order_items
//                if let number = Int("\((order_item.quantity)!)") {
//                    total = total+number
//                    
//                }
//                
//            }
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate.getCurrentOrderId()!)
            self.buttonCart.setTitle("\(totalCount)", for: UIControlState());
            self.buttonCart.setTitle("\(totalCount)", for: UIControlState.highlighted);
            
            
//            let orderItems:NSArray = DataManager.GetAllOrderItemsForOrderId(self.appDelegate.getCurrentOrderId()! )
//            self.buttonCart.setTitle("\(orderItems.count)", forState: UIControlState.Normal);
//            self.buttonCart.setTitle("\(orderItems.count)", forState: UIControlState.Highlighted);

        }else{
            self.buttonCart.setTitle("0", for: UIControlState());
            self.buttonCart.setTitle("0", for: UIControlState.highlighted);
        }
        
        let barButton = UIBarButtonItem(customView: self.buttonCart)
        self.navigationItem.rightBarButtonItem = barButton
        
        self.buttonAdd.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.buttonAdd.layer.borderWidth = 2.0
        
        self.buttonQuantity.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.buttonQuantity.layer.borderWidth = 2.0
        
        self.buttonSize.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.buttonSize.layer.borderWidth = 2.0
        
        self.buttonColor.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.buttonColor.layer.borderWidth = 2.0
        self.quantity = 1
        

        self.colorController = ColorPickerViewControlelrViewController(nibName: "ColorPickerViewControlelrViewController", bundle: nil)
        self.colorController.product = self.selectedProduct
        self.colorController.completionHandler = {
            (selectedObject:Color_manage) -> Void in
            self.selectedColor = selectedObject
            
            self.lblColorValue.text = selectedObject.color
            self.lblColorValue.sizeToFit()
            self.lblColorValue.adjustsFontSizeToFitWidth = true
        }

        self.sizePickerController = SizePickerViewController(nibName: "SizePickerViewController", bundle: nil)
        self.sizePickerController.product = self.selectedProduct
        self.sizePickerController.completionHandler = {
            (selectedObject:Size_manage) -> Void in
            self.selectedSize = selectedObject
            self.buttonSize.setTitle(selectedObject.size, for: UIControlState())
            self.priceUpc = DataManager.GetPriceUpchargeFor((self.selectedSize?.size)!, categoryId: (self.selectedProduct?.collection_id)!)
            var total = (self.selectedProduct!.price!.intValue * self.quantity!)
            if self.priceUpc != nil {
                total = total + ((self.priceUpc?.price?.intValue)! * self.quantity!)
            }
            self.labelPrice.text = "$\((total))"

        }

        self.quantityPickerController = QuantityPickerViewController(nibName: "QuantityPickerViewController", bundle: nil)
        self.quantityPickerController.completionHandler = {
            (selectedObject:String) -> Void in
            self.quantutyString = selectedObject
            self.labelQuantityToAdd.text = "+\(selectedObject)"
            self.quantity = Int(selectedObject)
            self.buttonQuantity.setTitle(selectedObject, for: UIControlState())
            var total = (self.selectedProduct!.price!.intValue * self.quantity!)
            if self.priceUpc != nil {
                total = total + ((self.priceUpc?.price?.intValue)! * self.quantity!)
            }
            self.labelPrice.text = "$\((total))"
        }

        self.labelStyle.text = "Style: \((self.selectedProduct?.style)!)"
        self.labelPrice.text = "$\((self.selectedProduct?.price?.stringValue)!)"
        self.labelFabric.text = "Fabric: \((self.selectedProduct?.fabric)!)"
        self.labelFabric.adjustsFontSizeToFitWidth = true
        self.labelPrice.adjustsFontSizeToFitWidth = true
        self.labelStyle.adjustsFontSizeToFitWidth = true

        var colorString:String = "Color: "
        let colorArray = DataManager.GetColorsForSelectedProducts(selectedProduct!)
        if(colorArray.count > 0){
            for index in 0...colorArray.count-1{
                let color :Color_manage = colorArray[index] as! Color_manage
                colorString = colorString + "\((color.color)!)"
                if(index != colorArray.count-1){
                    colorString = colorString + ", "
                }
            }
        }
        self.labelColor.text = colorString
        self.labelColor.adjustsFontSizeToFitWidth = true
        self.labelQuantityToAdd.text = ""

    }
    
    func setupButton(_ button: UIButton) {
        let spacing: CGFloat = 6.0
        let imageSize: CGSize = button.imageView!.image!.size
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        let labelString = NSString(string: button.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0)
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

    @IBAction func colorAction(_ sender: AnyObject) {
//        self.showColorPickerView = !self.showColorPickerView
//        self.colorPickerView.hidden = self.showColorPickerView
        showColorPickers(sender)

    }
    
    @IBAction func sizeAction(_ sender: AnyObject) {
        showSizePickers(sender)
    }
    
    @IBAction func quantityAction(_ sender: AnyObject) {
        showQuantityPickers (sender)
    }
    
    @IBAction func addAction(_ sender: AnyObject) {
        
        if(!self.isCorrect()){
            let alert = UIAlertController(title: "Error", message: "Please select correct input value", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return

        }
        
        if(self.appDelegate.getCurrentOrderId() == nil){
            let timeInterval = Date().timeIntervalSince1970

            if(appDelegate?.selectedStore != nil){

                var orderid:String = "\((self.appDelegate!.getCurrentSalesmanId())!)\(timeInterval)"
                orderid = orderid.replacingOccurrences(of: " ", with: "_")
                orderid = orderid.replacingOccurrences(of: "+", with: "_")
                orderid = orderid.replacingOccurrences(of: ".", with: "")

                self.appDelegate.setCurrentOrderId(orderid)
                
            }else{
                var orderid:String = "\((self.appDelegate!.getCurrentSalesmanId())!)\(timeInterval)"
                orderid = orderid.replacingOccurrences(of: " ", with: "_")
                orderid = orderid.replacingOccurrences(of: "+", with: "_")
                orderid = orderid.replacingOccurrences(of: ".", with: "")

                self.appDelegate.setCurrentOrderId(orderid)

            }
            let orders:Orders? = DataManager.initializeSize_orders()
            orders!.id = "\(self.appDelegate!.getCurrentOrderId()!)"
            orders!.order_id = (self.appDelegate.getCurrentOrderId())!
            orders!.salesman_id = self.appDelegate!.getCurrentSalesmanId()
            orders!.ship_to = ""
            orders!.bill_to = ""
            orders!.catelouge = ""
//            orders!.order_date = NSDate ()
//            orders!.start_date = NSDate ()
//            orders!.complition_date = NSDate ()
            orders!.order_note = ""
            orders!.signature = ""
            orders!.order_submitted = NSNumber(value: false as Bool)
            orders!.order_editable    = NSNumber(value: false as Bool)
            
            orders!.created_on = Date()
            DataManager.SaveOrders(orders!)
            
        }
        
        let orderItems:Order_items = DataManager.initializeSize_order_items()
        orderItems.id = "\(Date ())"
        orderItems.order_id = self.appDelegate.getCurrentOrderId()
        orderItems.product_id = (self.selectedProduct?.id?.stringValue)!
        orderItems.color = (self.selectedColor?.color)!
        orderItems.size = (self.selectedSize?.size)!
        orderItems.quantity = (self.quantutyString)!
//        var total = self.selectedProduct!.price!.floatValue * NSNumber(integer:self.quantity!).floatValue /* NSNumber(integer:self.size!).floatValue*/
        
        self.priceUpc = DataManager.GetPriceUpchargeFor((self.selectedSize?.size)!, categoryId: (self.selectedProduct?.collection_id)!)
        var total = (self.selectedProduct!.price!.intValue * self.quantity!)
        if(self.priceUpc != nil) {
            total = total + ((self.priceUpc?.price?.intValue)! * self.quantity!)
        }
        self.labelPrice.text = "$\((total))"
        orderItems.price = NSNumber(value: total as Int)
        orderItems.style = (self.selectedProduct?.style)!
        orderItems.note = ""
        orderItems.unit_price = self.selectedProduct?.price
        DataManager.SaveOrderItems(orderItems)
        
        if(self.appDelegate.getCurrentOrderId() != nil){
            
            
            self.buttonCart.setTitle("+\((self.quantutyString)!)", for: UIControlState());
            self.buttonCart.setTitle("+\((self.quantutyString)!)", for: UIControlState.highlighted);
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                let orderItems:NSArray = DataManager.GetAllOrderItemsForOrderId(self.appDelegate.getCurrentOrderId()! )
                var total = 0
                for item in orderItems{
                    let order_item : Order_items = item as! Order_items
                    if let number = Int("\((order_item.quantity)!)") {
                        total = total+number
                        
                    }
                    
                }
                self.buttonCart.setTitle("\(total)", for: UIControlState());
                self.buttonCart.setTitle("\(total)", for: UIControlState.highlighted);
            })
            
        }

    }
    
    func isCorrect()->Bool{
        
        var correct:Bool = false
        if(self.selectedProduct != nil && self.selectedColor != nil && self.selectedSize != nil && (self.labelQuantityToAdd.text)!.characters.count > 0){
            correct = true
        }
        return correct
    }
    
    @IBAction func pichImageAction(_ sender: AnyObject) {
//        let alert = UIAlertController(title: "Coming soon!!", message: "We are currently working on this page", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        let controller:PichandZoomImageViewControlelrViewController = PichandZoomImageViewControlelrViewController(nibName: "PichandZoomImageViewControlelrViewController", bundle: nil)
        controller.product = self.selectedProduct
//        self.presentViewController(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)

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
    
    func showColorPickers(_ sender:AnyObject){
        
        self.colorController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.colorPopover = self.colorController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 200,height: 200)
        
        self.colorController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.colorPopover.sourceView = viewForSource
        self.colorPopover.sourceRect = viewForSource.bounds;

        self.colorPopover.permittedArrowDirections = UIPopoverArrowDirection.down/*(rawValue: 0)*/
        
        present(self.colorController,
                              animated: true, completion:nil)
        
    }
    
    func showSizePickers(_ sender:AnyObject){
        
        self.sizePickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.sizePopover = self.sizePickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 200,height: 200)
        
        self.sizePickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.sizePopover.sourceView = viewForSource
        self.sizePopover.sourceRect = viewForSource.bounds;
        
        self.sizePopover.permittedArrowDirections = UIPopoverArrowDirection.down/*(rawValue: 0)*/
        
        present(self.sizePickerController,
                              animated: true, completion:nil)
        
    }
    
    func showQuantityPickers(_ sender:AnyObject){
        
        self.quantityPickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.quantityPopover = self.quantityPickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 200,height: 200)
        
        self.quantityPickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.quantityPopover.sourceView = viewForSource
        self.quantityPopover.sourceRect = viewForSource.bounds;
        
        self.quantityPopover.permittedArrowDirections = UIPopoverArrowDirection.down/*(rawValue: 0)*/
        
        present(self.quantityPickerController,
                              animated: true, completion:nil)
        
    }

    @IBAction func cartAction(_ sender: AnyObject) {
        let controller:OrderViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true);
    }
    
    @IBAction func playVide(_ sender: AnyObject) {
        let image:String = DataManager.GetImageFromImageUrl((self.selectedProduct?.video)!)!
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/*- 38*/
        let height = UIScreen.main.bounds.size.height - (206+47)
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((imageArray?.count)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SSCollectionViewCell", for: indexPath) as! SSCollectionViewCell
        let item : String = imageArray![indexPath.row] as! String
        let imageFieldName = (item as NSString).lastPathComponent
       
        cell.playButton.isHidden = true
        loadImageFromUrl(imageFieldName, view: cell.cellImage)
        
        cell.cellImage.contentMode = UIViewContentMode.scaleToFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let curretntPage:NSInteger = (NSInteger) (self.productCollectionView.contentOffset.x/self.productCollectionView.frame.size.width)
        
        self.pageControl.currentPage = curretntPage
        
        
    }
    
    
}

extension UIAlertController {
    
    open override var shouldAutorotate : Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
}
