//
//  DashBoardViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/2/16.
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


class DashBoardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelPending: UILabel!
    @IBOutlet weak var labelOrderSend: UILabel!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet weak var tableDashBoard: UITableView!
    var orderArray : NSArray?
    var appDelegate:AppDelegate!
    var selectedIndexes : NSMutableArray?
    var uploadIndex = 0
    var uploadOrderCount = 0
    var selectedOrders :  NSMutableArray = []
    
    @IBOutlet weak var btnSelectAll: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDashBoard.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        self.tableDashBoard.separatorStyle = UITableViewCellSeparatorStyle.none
        self.navigationItem.title="ORDERS SUBMITTED"
        
        let barButton = UIBarButtonItem(customView: self.btnSend)
        self.navigationItem.rightBarButtonItem = barButton
        self.orderArray = DataManager.GetAllCompletedOrders()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.selectedIndexes = NSMutableArray()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let editableCount = DataManager.GetAllEditableOrders().count
        let allOrderCount = DataManager.GetAllCompletedOrders().count
        
        self.appDelegate?.removeFromCurrentOrder()
        
        labelPending.text = "\(editableCount) INCOMPLETE"
        labelOrderSend.text = "\(allOrderCount - editableCount)  COMPLETE"


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.orderArray?.count)!
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :DashboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
        let order:Orders = self.orderArray![indexPath.row] as! Orders
        /*
         json value: ["status": ok, "order_id": 1ORD2016-11-11 18:00:48  0000, "message": Order Updated Successfully]
         
         ["status": ok, "order_id": 1ORD2016-11-11_18:12:52__0000, "message": Order Updated Successfully]
         */
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        cell.labelDate.text = "\(df.string(from: (order.order_date)!))"
        let store:Store = DataManager.GetStoreForStoreAcNumber((order.store_id)!)!
        cell.labelShop.text = "\((store.name)!)"
        
        
        let orderItems:NSArray? = DataManager.GetAllOrderItemsForOrderId((order.id)!)
        if(orderItems?.count > 0){
            let orderItem:Order_items = orderItems![0] as! Order_items
            print ("there \(orderItem.product_id ?? "")")
            
            
            let product:Products? = DataManager.GetProductForProductId((orderItem.product_id)!)
            if (product != nil){
                let collection:Collections = DataManager.GetCollectionForCollectionId(product!.collection_id!)!;
                cell.labelCollection.text = "\(collection.name!)"
            }
            
        }
        
        
       
        if(order.short_order_id != nil){
             cell.labelPO.text = "\(order.short_order_id!)         \((order.po)!)";
        }else{
             cell.labelPO.text = "\((order.po)!)";
        }
        let totalCount = DataManager.getTotalItemCountForOrderId((order.order_id)!)
        cell.labelCount.text = "\(totalCount)"
        cell.buttonSelection.addTarget(self, action: #selector(DashBoardViewController.orderSelected(_:)), for: UIControlEvents.touchUpInside)
        if(self.selectedIndexes?.contains(indexPath) == true){
            cell.buttonSelection.setImage(UIImage(named: "check_on"), for: UIControlState())
        }else{
            cell.buttonSelection.setImage(UIImage(named: "check_off"), for: UIControlState())

        }
        
        if(order.order_editable == true){
            cell.imageStatus.image = UIImage (named: "cross");
//            cell.buttonSelection.userInteractionEnabled = true;
        }else{
            cell.imageStatus.image = UIImage (named: "right");
//            cell.buttonSelection.userInteractionEnabled = false;

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order:Orders = self.orderArray![indexPath.row] as! Orders

        if(order.order_editable == true){
            let store:Store = DataManager.GetStoreForStoreAcNumber((order.store_id)!)!
            self.appDelegate.selectedStore = store
            
            
            self.appDelegate.setCurrentOrderId("\((order.order_id)!)")
            
            let controller:OrderViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
            self.navigationController?.pushViewController(controller, animated: true);
        }
    }
    

    func orderSelected(_ sender:UIButton)
    {
        let cell:DashboardTableViewCell = sender.superview?.superview as! DashboardTableViewCell
        let indexPath:IndexPath = self.tableDashBoard.indexPath(for: cell)!
//        let order:Orders = self.orderArray![indexPath.row] as! Orders
//
//        if(order.order_editable == false){
//            NSOperationQueue.mainQueue().addOperationWithBlock {
//                let actionSheetController: UIAlertController = UIAlertController(title: "Error!", message: "This order is already submitted", preferredStyle: .Alert)
//                actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
//                
//                self.presentViewController(actionSheetController, animated: true, completion: nil)
//            }
//
//            return;
//        }

        if(self.selectedIndexes?.contains(indexPath) == true){
            self.selectedIndexes?.remove(indexPath)
            cell.buttonSelection.setImage(UIImage(named: "check_off"), for: UIControlState())

        }else{
            self.selectedIndexes?.add(indexPath)
            cell.buttonSelection.setImage(UIImage(named: "check_on"), for: UIControlState())

        }
        
        if(self.selectedIndexes?.count == self.orderArray?.count){
            self.btnSelectAll.setImage(UIImage(named: "check_on"), for: UIControlState())
            
        }else{
            self.btnSelectAll.setImage(UIImage(named: "check_off"), for: UIControlState())
            
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

    @IBAction func sendAction(_ sender: AnyObject) {
        
        self.selectedOrders  = NSMutableArray()
        if(self.selectedIndexes?.count > 0) {
            for selectedIndex in 0...((self.selectedIndexes?.count)!-1){
                let indexPath: IndexPath = self.selectedIndexes?.object(at: selectedIndex) as! IndexPath
                selectedOrders.add((self.orderArray?.object(at: indexPath.row))!)
            }
            self.uploadIndex = 0
            uploadOrderCount = self.selectedOrders.count
            if(self.selectedOrders.count >= 1){
                self.uploadOrderAtIndex(self.uploadIndex)
                self.uploadIndex = self.uploadIndex+1
                
            }

        }
        
        
    }
    
    
    @IBAction func allSelectedAction(_ sender: AnyObject) {
        
        if(self.selectedIndexes?.count != self.orderArray?.count){
            for selectedIndex in 0...((self.orderArray?.count)!-1){
                let indexPath: IndexPath = IndexPath(row: selectedIndex, section: 0)
//                let order:Orders = self.orderArray![indexPath.row] as! Orders
//                if(order.order_editable == true){
//                    self.selectedIndexes!.addObject(indexPath)
//                }
                self.selectedIndexes!.add(indexPath)

            }
        }
        
        self.tableDashBoard.reloadData()
        
        if(self.selectedIndexes?.count == self.orderArray?.count){
            self.btnSelectAll.setImage(UIImage(named: "check_on"), for: UIControlState())
            
        }else{
            self.btnSelectAll.setImage(UIImage(named: "check_off"), for: UIControlState())
            
        }
    }
   
    
    func uploadOrderAtIndex(_ index: NSInteger){
        if Reachability.isConnectedToNetwork() == true {
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        self.startActivity(self.view!)

        let indexPath : IndexPath = self.selectedIndexes![index] as! IndexPath
        let order:Orders = self.orderArray![indexPath.row] as! Orders
        if(order.order_editable == false){
            DispatchQueue.main.async {
                self.stopActivity(self.view!)

                if(self.uploadIndex < self.uploadOrderCount){                     self.uploadOrderAtIndex(self.uploadIndex)
                    self.uploadIndex = self.uploadIndex+1
                    
                }else{
                    let editableCount = DataManager.GetAllEditableOrders().count
                    let allOrderCount = DataManager.GetAllCompletedOrders().count
                    self.labelPending.text = "\(editableCount) INCOMPLETE"
                    self.labelOrderSend.text = "\(allOrderCount - editableCount) COMPLETE"
                    DispatchQueue.main.async {
                        self.tableDashBoard.reloadData()
                    }
                    
                }
                
                
            }
            return;
        }
        
        
        let store:Store = DataManager.GetStoreForStoreAcNumber((order.store_id)!)!
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let urlString:String = "https://davincibridal.com/salesapp/action/insert_order_details"
        let base64String = order.image!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

        var request = URLRequest(url: URL(string: urlString)!)
        //let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        print("base64 -> \(base64String)")
        
        
        let orderItems : NSArray = DataManager.GetAllOrderItemsForOrderId((order.id)!)
        let orderItemsArray : NSMutableArray = NSMutableArray()
        for index in 0...orderItems.count-1 {
            
            let orderItem:Order_items = orderItems[index] as! Order_items
            
            let productDict : NSDictionary = ["product_id" : "\((orderItem.product_id)!)",
                                              "color" : "\((orderItem.color)!)",
                                              "size" : "\((orderItem.size)!)",
                                              "quantity" : "\((orderItem.quantity)!)",
                                              "price" : "\((orderItem.price)!)",
                                              "style" : "\((orderItem.style)!)",
                                              "note" : "\((orderItem.note)!)"]
            orderItemsArray.add(productDict)
            
        }
        
        var tempJson : String = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: orderItemsArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as String
            print ("\(tempJson)")
            
        }catch let error as NSError{
            print(error.description)
        }
        /*
         @NSManaged var contact: String?
         @NSManaged var phone: String?
         @NSManaged var fax: String?
         @NSManaged var email: String?
         */
        let postString = "order_id=\((order.order_id!))&account_number=\((store.account_number)!)&salesman_id=\((order.salesman_id)!)&ship_to=\((order.ship_to)!)&bill_to=\((order.bill_to)!)&po=\((order.po)!)&catelouge=\((order.catelouge)!)&order_date=\(df.string(from: (order.order_date)!))&start_date=\(df.string(from: (order.start_date)!))&completion_date=\(df.string(from: (order.complition_date)!))&order_note=\((order.order_note)!)&contact=\((order.contact)!)&phone=\((order.phone)!)&fax=\((order.fax)!)&email=\((order.email)!)&signature=\(base64String)&order_items=\(tempJson)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                                                  print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            do{
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("data value: \(datastring!)")

                let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                print("json value: \(dict)")
                if dict["order_id"] != nil {
                    
                    let order:Orders = DataManager.GetCurrentOrderForOrderId((dict["order_id"] as? String)!)
                    order.order_editable = NSNumber(value: false as Bool)
                    order.short_order_id = dict["updated_order_id"] as? String
                    DataManager.UpdateOrder(order)
                    if(self.appDelegate.getCurrentOrderId() == (order.order_id)!){
                        self.appDelegate.removeFromCurrentOrder()
                    }
                }
                
                
            }
            catch {
                print("json error: \(error)")
            }
            
            DispatchQueue.main.async {
                self.stopActivity(self.view!)

                if(self.uploadIndex < self.uploadOrderCount){
                    self.uploadOrderAtIndex(self.uploadIndex)
                    self.uploadIndex = self.uploadIndex+1

                }else{
                    let editableCount = DataManager.GetAllEditableOrders().count
                    let allOrderCount = DataManager.GetAllCompletedOrders().count
                    self.labelPending.text = "\(editableCount) INCOMPLETE"
                    self.labelOrderSend.text = "\(allOrderCount - editableCount) COMPLETE"
                    DispatchQueue.main.async {
                        self.tableDashBoard.reloadData()
                    }

                }
                
                
            }
            
        }) 
        task.resume()
    }
}
