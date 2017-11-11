//
//  OrderViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/29/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
import SRKControls
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


class OrderViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,SRKDateTimeBoxDelegate,UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var labelTotalOrder: UILabel!
    @IBOutlet weak var btnOrderNotes: UIButton!
    @IBOutlet weak var btnCompare: UIButton!
    @IBOutlet weak var btnAddProducts: UIButton!
    @IBOutlet weak var viewShipTo: UIView!
    @IBOutlet weak var viewBillTo: UIView!
    @IBOutlet weak var orderTable: UITableView!
    
    @IBOutlet weak var btnSameAsBill: UIButton!
    @IBOutlet weak var txtSalesMan: UITextField!
    
    @IBOutlet weak var txtPO: UITextField!
    
    @IBOutlet weak var txtcatelog: UITextField!
    
    @IBOutlet weak var txtOrderDate: SRKDateTimeBox!
    
    @IBOutlet weak var txtStartDate: SRKDateTimeBox!
    
    @IBOutlet weak var txtCompDate: SRKDateTimeBox!
    
    @IBOutlet weak var imageSameAsBill: UIImageView!
    
    @IBOutlet weak var txtContact: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtFax: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var viewOrderInput: UIView!
    
    var addressController:AddressViewController!
    var addressPopover: UIPopoverPresentationController!
    
    var signatureController:SignatureViewController!
    var signaturePopover: UIPopoverPresentationController!
    
    var noteController:NoteViewController!
    var notePopover: UIPopoverPresentationController!
    
    var colorController:ColorPickerViewControlelrViewController!
    var colorPopover: UIPopoverPresentationController!
    
    var sizePickerController:SizePickerViewController!
    var sizePopover:UIPopoverPresentationController!
    
    var quantityPickerController : QuantityPickerViewController!
    var quantityPopover:UIPopoverPresentationController!
    var appDelegate:AppDelegate!
    var order:Orders?
    var orderItems:NSArray?
    var  selectedIndexPath :IndexPath!
    var  currentIndexPath :IndexPath!
    var currentProduct:Products?
    var currentOrderItem:Order_items!
    var isNotePresented = false
    var sameAsBill = false
    var showOrderNote = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.txtContact.delegate = self
        self.txtPhone.delegate = self
        self.txtFax.delegate = self
        self.txtEmail.delegate = self
        self.txtSalesMan.delegate = self
        self.txtcatelog.delegate = self
        self.txtPO.delegate = self

        if(self.appDelegate.selectedStore != nil){
            if(self.appDelegate.selectedStore?.contact?.characters.count > 0){
                self.txtContact.text = "\((self.appDelegate.selectedStore?.contact)!)"

            }
            if(self.appDelegate.selectedStore?.phone?.characters.count > 0){
                self.txtPhone.text = "\((self.appDelegate.selectedStore?.phone)!)"
                
            }
            if(self.appDelegate.selectedStore?.fax?.characters.count > 0){
                self.txtFax.text = "\((self.appDelegate.selectedStore?.fax)!)"
                
            }
            if(self.appDelegate.selectedStore?.email?.characters.count > 0){
                self.txtEmail.text = "\((self.appDelegate.selectedStore?.email)!)"
                
            }
            
            
//            df.dateFormat = "dd-MMM-yyyy"
//            self.txtOrderDate.text = df.stringFromDate((order?.order_date)!)
//            self.txtStartDate.text = df.stringFromDate((order?.start_date)!)
//            self.txtCompDate.text = df.stringFromDate((order?.complition_date)!)
            
            /*
             let address =  AddressFormatter.splitAddressToAddresslines(selectedOrder.bill_to!)
             if(address?.count > 0){
             self.addressLine1.text = "\((address![0] as? String)!)"
             }
             if(address?.count > 1){
             self.addressLine2.text =  "\((address![1] as? String)!)"
             }
             if(address?.count > 2){
             self.addressLine3.text =  "\((address![2] as? String)!)"
             }
             
             self.city.text = "\((AddressFormatter.splitAddressToCity(selectedOrder.bill_to!)!))"
             self.state.text = "\((AddressFormatter.splitAddressToState(selectedOrder.bill_to!)!))"
             self.zip.text = "\((AddressFormatter.splitAddressToZip(selectedOrder.bill_to!)!))"
             */
            
            

            
        }
        
       
 
        
        if(self.appDelegate!.getCurrentSalesmanId() != nil){
            let salesman: Salesman = DataManager.GetCurrentSalesmanFromId(self.appDelegate!.getCurrentSalesmanId()!)! as Salesman
            self.txtSalesMan.text = (salesman    .name)!
//            self.txtFax.text = (salesman    .fax)!
//            self.txtEmail.text = (salesman    .email)!
//            self.txtContact.text = (salesman    .contact)!
//            self.txtPhone.text = (salesman    .phone)!
            
        }
        
        
        if(self.appDelegate.getCurrentOrderId() != nil){
            
            order = DataManager.GetCurrentOrderForOrderId(self.appDelegate.getCurrentOrderId()!)
            orderItems = DataManager.GetAllOrderItemsForOrderId((order?.id)!)
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)
            
            if(self.appDelegate.selectedStore?.address1 != nil && self.appDelegate.selectedStore?.address2 != nil){
                if(order?.bill_to?.characters.count <= 0){
                    let address:String = AddressFormatter.getAddressFromAddresLine((self.appDelegate.selectedStore?.address1!)!, addressline2: (self.appDelegate.selectedStore?.address2!)!, addressline3: "", city: (self.appDelegate.selectedStore?.city!)!, state: (self.appDelegate.selectedStore?.state!)!, zip: (self.appDelegate.selectedStore?.zip!)!)
                    order?.bill_to = "\(address)"
                }
                
            }
            
            if(self.appDelegate.selectedStore?.shipping_address1 != nil && self.appDelegate.selectedStore?.shipping_address2 != nil){
                if(order?.ship_to?.characters.count <= 0){
                    let address:String = AddressFormatter.getAddressFromAddresLine((self.appDelegate.selectedStore?.shipping_address1!)!, addressline2: (self.appDelegate.selectedStore?.shipping_address2!)!, addressline3: "", city: (self.appDelegate.selectedStore?.shipping_city!)!, state: (self.appDelegate.selectedStore?.shipping_state!)!, zip: (self.appDelegate.selectedStore?.shipping_zip!)!)
                    order?.ship_to = "\(address)"
                }
                
            }
            
            
            self.labelTotalOrder.text = "Total: \(totalCount)"
            if(self.order?.po?.characters.count > 0){
                self.txtPO.text = "\((self.order?.po)!)"

            }
            if(self.order?.po?.characters.count > 0){
                self.txtPO.text = "\((self.order?.po)!)"
                
            }
            if(self.order?.contact?.characters.count > 0){
                self.txtContact.text = "\((self.order?.contact)!)"
                
            }
            if(self.order?.phone?.characters.count > 0){
                self.txtPhone.text = "\((self.order?.phone)!)"
                
            }
            if(self.order?.fax?.characters.count > 0){
                self.txtFax.text = "\((self.order?.fax)!)"
                
            }
            if(self.order?.email?.characters.count > 0){
                self.txtEmail.text = "\((self.order?.email)!)"
                
            }
            if(self.order?.catelouge?.characters.count > 0){
                self.txtcatelog.text = "\((self.order?.catelouge)!)"
                
            }

        }else{
            orderItems = NSArray()
            let alert = UIAlertController(title: "No Data Found!!", message: "Currently there is no active order", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        

        self.orderTable.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        self.navigationItem.title="PLACE ORDER"
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(OrderViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5 // 0.5 second press
        self.orderTable.addGestureRecognizer(longPressGesture)
        
        self.viewShipTo.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.viewShipTo.layer.borderWidth = 2.0
        
        self.viewBillTo.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.viewBillTo.layer.borderWidth = 2.0
        
        self.btnSubmit.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.btnSubmit.layer.borderWidth = 2.0
        
        self.btnCompare .layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.btnCompare.layer.borderWidth = 2.0
        
        self.btnOrderNotes.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.btnOrderNotes.layer.borderWidth = 2.0
        
        self.btnAddProducts.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.btnAddProducts.layer.borderWidth = 2.0
        
        self.addressController = AddressViewController(nibName: "AddressViewController", bundle: nil)
        self.noteController = NoteViewController(nibName: "NoteViewController", bundle: nil)
        self.noteController.completionHandler = {
            () -> Void in
            self.isNotePresented = false
            self.orderTable.reloadData()
            
        }
        
        
        
        
        self.signatureController = SignatureViewController(nibName: "SignatureViewController", bundle: nil)
        self.signatureController.completionHandler = {
            (selectedImage:UIImage) -> Void in
            self.order?.order_submitted = NSNumber(value: true as Bool)
            self.order?.order_editable = NSNumber(value: true as Bool)
            
            if(self.appDelegate.selectedStore != nil){
                self.order?.store_id = (self.appDelegate.selectedStore?.account_number)!
            }
            if(self.appDelegate.currentSalesMan != nil){
                self.order?.salesman_id = (self.appDelegate.currentSalesMan?.id)!
            }
            
            self.order?.po = (self.txtPO.text)!
            self.order?.contact = (self.txtContact.text)!
            self.order?.phone = (self.txtPhone.text)!
            self.order?.fax = (self.txtFax.text)!
            self.order?.email = (self.txtEmail.text)!
            self.order?.catelouge = (self.txtcatelog.text)!
            
            let df = DateFormatter()           
            df.dateFormat = "dd-MMM-yyyy"
            self.order?.order_date = df.date(from: self.txtOrderDate.text!)
            self.order?.complition_date = df.date(from: self.txtCompDate.text!)
            self.order?.start_date = df.date(from: self.txtStartDate.text!)

//            let image : UIImage = UIImage(named:"check_on")!
            //Now use image to create into NSData format
//            let imageData:NSData = UIImagePNGRepresentation(image)!
            
            self.order?.image = UIImagePNGRepresentation(selectedImage)!//UIImagePNGRepresentation(selectedImage)
            
            

            
            DataManager.UpdateOrder(self.order!)
            if(self.appDelegate.getCurrentOrderId() != nil){
                self.appDelegate.saveCurrentOrder()
            }
            self.navigationController?.popToRootViewController(animated: true)

            
           
        }
        
        
        
        updateTextFieldDesign(self.txtSalesMan);
        updateTextFieldDesign(self.txtPO);
        updateTextFieldDesign(self.txtcatelog);
        updateTextFieldDesign(self.txtOrderDate);
        updateTextFieldDesign(self.txtStartDate);
        updateTextFieldDesign(self.txtCompDate);
        
        updateTextFieldDesign(self.txtContact);
        updateTextFieldDesign(self.txtPhone);
        updateTextFieldDesign(self.txtFax);
        updateTextFieldDesign(self.txtEmail);
        
        
        self.colorController = ColorPickerViewControlelrViewController(nibName: "ColorPickerViewControlelrViewController", bundle: nil)
        self.colorController.completionHandler = {
            (selectedObject:Color_manage) -> Void in
            if self.currentIndexPath != nil {
                let orderItem:Order_items = self.orderItems![self.currentIndexPath.row] as! Order_items
                orderItem.color = selectedObject.color
                self.orderTable.reloadRows(at: [self.currentIndexPath], with: UITableViewRowAnimation.none);
                DataManager.UpdateOrderItem(orderItem)
            }
            
        }
        
        self.sizePickerController = SizePickerViewController(nibName: "SizePickerViewController", bundle: nil)
        self.sizePickerController.completionHandler = {
            (selectedObject:Size_manage) -> Void in
            if self.currentIndexPath != nil {
                let orderItem:Order_items = self.orderItems![self.currentIndexPath.row] as! Order_items
                orderItem.size = selectedObject.size
                let priceUpc: Pricing_upcharge? = DataManager.GetPriceUpchargeFor(orderItem.size!, categoryId: (self.currentProduct?.collection_id)!)
                var total = orderItem.unit_price!.intValue
                if priceUpc != nil {
                    total = (total + (priceUpc?.price?.intValue)!) * NSNumber(value: Int(orderItem.quantity!)! as Int).intValue
                }else{
                    total = total * NSNumber(value: Int(orderItem.quantity!)! as Int).intValue
                }
                orderItem.price = NSNumber(value: total as Int)
                self.orderTable.reloadRows(at: [self.currentIndexPath], with: UITableViewRowAnimation.none);
                DataManager.UpdateOrderItem(orderItem)
            }
            

        }
        
        self.quantityPickerController = QuantityPickerViewController(nibName: "QuantityPickerViewController", bundle: nil)
        self.quantityPickerController.completionHandler = {
            (selectedObject:String) -> Void in
            if self.currentIndexPath != nil {
                let orderItem:Order_items = self.orderItems![self.currentIndexPath.row] as! Order_items
                orderItem.quantity = selectedObject
                let priceUpc: Pricing_upcharge? = DataManager.GetPriceUpchargeFor(orderItem.size!, categoryId:(self.currentProduct?.collection_id)!)
                var total = orderItem.unit_price!.intValue
                if priceUpc != nil {
                    total = (total + (priceUpc?.price?.intValue)!) * NSNumber(value: Int(selectedObject)! as Int).intValue
                }else{
                    total = total * NSNumber(value: Int(orderItem.quantity!)! as Int).intValue
                }

                orderItem.price = NSNumber(value: total as Int)
                let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)
                self.labelTotalOrder.text = "Total: \(totalCount)"
                
                self.orderTable.reloadRows(at: [self.currentIndexPath], with: UITableViewRowAnimation.none);
                DataManager.UpdateOrderItem(orderItem)
            }
        }
        //df.dateFormat = "dd-MMM-yyyy"
        
        let store_date : Store_date = DataManager.GetStoreDate()
        if (store_date.start_date != nil && order?.order_date == nil){
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yyyy"
            self.txtOrderDate.text = df.string(from: Date()/*(store_date.start_date)!*/)
        }
        if (store_date.completion_date != nil && order?.complition_date == nil){
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yyyy"
            self.txtCompDate.text = df.string(from: (store_date.completion_date)!)
        }
        if (store_date.end_date != nil && order?.start_date == nil){
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yyyy"
            self.txtStartDate.text = df.string(from: (store_date.start_date)!)
        }
        if orderItems?.count > 0 {
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yyyy"
            if order?.order_date != nil {
                self.txtOrderDate.text = df.string(from: (order?.order_date)!)

            }
            
            if order?.start_date != nil {
                self.txtStartDate.text = df.string(from: (order?.start_date)!)

            }
            
            if order?.complition_date != nil {
                self.txtCompDate.text = df.string(from: (order?.complition_date)!)
                
            }
        }
        

       


    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if ((order?.order_editable?.boolValue) == true) {
            DataManager.UpdateOrder(order!)
        }
        
        if(self.appDelegate.getCurrentOrderId() != nil){
            self.order?.po = (self.txtPO.text)!
            self.order?.contact = (self.txtContact.text)!
            self.order?.phone = (self.txtPhone.text)!
            self.order?.fax = (self.txtFax.text)!
            self.order?.email = (self.txtEmail.text)!
            self.order?.catelouge = (self.txtcatelog.text)!
            if(self.appDelegate.selectedStore != nil){
                self.order?.store_id = (self.appDelegate.selectedStore?.account_number)!
            }
            DataManager.UpdateOrder(order!)

        }
    }
    
    func updateTextFieldDesign (_ textField:UITextField){

        textField.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        textField.layer.borderWidth = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAddress(_ addressType : String){
        
        
        self.addressController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        var expected:CGSize!
        expected = CGSize(width: 500,height: 300)
        self.addressController.preferredContentSize = expected
        self.navigationController!.present(self.addressController,
                                                         animated: true, completion:nil)
        
        self.addressController.headerLabel?.text = addressType

    }
    
    func showSignature(){
        
        
        self.signatureController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        var expected:CGSize!
        expected = CGSize(width: 600,height: 400)
        self.signatureController.preferredContentSize = expected
        self.navigationController!.present(self.signatureController,
                              animated: true, completion:nil)
        
        
    }
    
    func showNote(_ noteType : String){
        if(!isNotePresented){
            isNotePresented = true
            if(self.showOrderNote){
                self.noteController.order = order
                self.noteController.orderItemNote = false
            }else{
                self.noteController.order_item = currentOrderItem
                self.noteController.orderItemNote = true
            }
            
            self.noteController .modalPresentationStyle = UIModalPresentationStyle.formSheet
            var expected:CGSize!
            expected = CGSize(width: 500,height: 300)
            self.noteController.preferredContentSize = expected
            self.navigationController!.present(self.noteController,
                                                             animated: true, completion:nil)
            self.noteController.noteLabe.text = noteType
        }
        
        
        
    }
    
    func showColorPickers(_ sender:AnyObject){
        
        self.colorController.product = self.currentProduct
        
        self.colorController.resetColorValue()
        
        self.colorController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.colorPopover = self.colorController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 200,height: 200)
        
        self.colorController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.colorPopover.sourceView = viewForSource
        self.colorPopover.sourceRect = viewForSource.bounds;
        
        self.colorPopover.permittedArrowDirections = UIPopoverArrowDirection.any/*(rawValue: 0)*/
        
        present(self.colorController,
                              animated: true, completion:nil)
        
    }
    
    func showSizePickers(_ sender:AnyObject){
        
        self.sizePickerController.product = self.currentProduct
        
        self.sizePickerController.resetSizeValue()
        
        self.sizePickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.sizePopover = self.sizePickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 200,height: 200)
        
        self.sizePickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.sizePopover.sourceView = viewForSource
        self.sizePopover.sourceRect = viewForSource.bounds;
        
        self.sizePopover.permittedArrowDirections = UIPopoverArrowDirection.any/*(rawValue: 0)*/
        
        present(self.sizePickerController,
                              animated: true, completion:nil)
        
    }
    
    func showQuantityPickers(_ sender:AnyObject, orderQuantity: String){
        
        self.quantityPickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.quantityPopover = self.quantityPickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 200,height: 200)
        
        self.quantityPickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.quantityPopover.sourceView = viewForSource
        self.quantityPopover.sourceRect = viewForSource.bounds;
        
        self.quantityPopover.permittedArrowDirections = UIPopoverArrowDirection.any/*(rawValue: 0)*/
        
        if self.quantityPickerController.selectedObjects == nil {
            self.quantityPickerController.selectedObjects = NSMutableArray()
        } else {
            self.quantityPickerController.selectedObjects.removeAllObjects()
        }
        self.quantityPickerController.selectedObjects = [orderQuantity]
        
        if self.quantityPickerController.quantityTable != nil {
            self.quantityPickerController.quantityTable.reloadData()
        }
        
        present(self.quantityPickerController,
                              animated: true, completion:nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (orderItems?.count)!
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :OrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.productQuantity.layer.borderColor=UIColor(red: 244/255.0, green: 205/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        cell.productQuantity.layer.borderWidth = 1.0
        
        cell.productSize.layer.borderColor=UIColor(red: 244/255.0, green: 205/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        cell.productSize.layer.borderWidth = 1.0
        
        cell.btnProcutColor.layer.borderColor=UIColor(red: 244/255.0, green: 205/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        cell.btnProcutColor.layer.borderWidth = 1.0
        cell.btnProcutColor.addTarget(self, action: #selector(OrderViewController.btnProcutColorClicked(_:)), for: UIControlEvents.touchUpInside)
        cell.productSize.addTarget(self, action: #selector(OrderViewController.btnProcutSizeClicked(_:)), for: UIControlEvents.touchUpInside)
        cell.productQuantity.addTarget(self, action: #selector(OrderViewController.btnProcutQuantityClicked(_:)), for: UIControlEvents.touchUpInside)
        
        cell.imageButton.addTarget(self, action: #selector(OrderViewController.moveToProdcut(_:)), for: UIControlEvents.touchUpInside)
        cell.styleButton.addTarget(self, action: #selector(OrderViewController.moveToProdcut(_:)), for: UIControlEvents.touchUpInside)
        cell.btnCopy.addTarget(self, action: #selector(OrderViewController.btnCopyProductClicked(_:)), for: UIControlEvents.touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(OrderViewController.btnDeleteProductClicked(_:)), for: UIControlEvents.touchUpInside)

        cell.editView.layer.borderColor=UIColor(red: 244/255.0, green: 205/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        cell.editView.layer.borderWidth = 1.0
        
        cell.blurView.isHidden = true
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        cell.textViewAboutProduct.delegate = self;
        cell.textViewAboutProduct.layer.borderColor=UIColor(red: 244/255.0, green: 205/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        cell.textViewAboutProduct.layer.borderWidth = 1.0
        
        cell.blurView.layer.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7).cgColor
        let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
//        let priceUpc:Pricing_upcharge = DataManager.GetPriceUpchargeFor("Two")!

        cell.totalPrice.text = "$\((orderItem.price)!)"
        cell.labelStyle.text = "\((orderItem.style)!)"
        cell.btnProcutColor.setTitle("\((orderItem.color)!)", for: UIControlState())
        cell.btnProcutColor.setTitle("\((orderItem.color)!)", for: UIControlState.highlighted)
        cell.productSize.setTitle("\((orderItem.size)!)", for: UIControlState())
        cell.productSize.setTitle("\((orderItem.size)!)", for: UIControlState.highlighted)
        cell.productQuantity.setTitle("\((orderItem.quantity)!)", for: UIControlState())
        cell.productQuantity.setTitle("\((orderItem.quantity)!)", for: UIControlState.highlighted)
        cell.productPrice.text = "$\((orderItem.unit_price)!)"
        cell.textViewAboutProduct.text = "\((orderItem.note)!)"
        alignTextVerticalInTextView(cell.textViewAboutProduct)
        
        let product:Products = DataManager.GetProductForProductId((orderItem.product_id)!)!
        
        let image:String = DataManager.GetImageFromImageUrl((product.primary_image)!)!
        loadImageFromUrl(image, view: cell.productImage)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 203;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let orderItem:Order_items = self.orderItems![indexPath.row] as! Order_items
//        let controller:ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
//        controller.selectedProduct = DataManager.GetProductForProductId(orderItem.product_id!)
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func alignTextVerticalInTextView(_ textView :UITextView) {
        
        let size = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat(MAXFLOAT)))
        
        var topoffset = (textView.bounds.size.height - size.height * textView.zoomScale) / 2.0
        topoffset = topoffset < 0.0 ? 0.0 : topoffset
        
        textView.contentOffset = CGPoint(x: 0, y: -topoffset)
    }
    
    func moveToProdcut(_ sender:UIButton)
    {
        let cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath:IndexPath = self.orderTable.indexPath(for: cell)!
        currentIndexPath = indexPath
        let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
        currentProduct = DataManager.GetProductForProductId(orderItem.product_id!)
        let controller:ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        controller.selectedProduct = DataManager.GetProductForProductId(orderItem.product_id!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func btnProcutColorClicked(_ sender:UIButton)
    {
        let cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath:IndexPath = self.orderTable.indexPath(for: cell)!
        currentIndexPath = indexPath
        let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
        currentProduct = DataManager.GetProductForProductId(orderItem.product_id!)
        showColorPickers(sender)
    }
    
    func btnProcutSizeClicked(_ sender:UIButton)
    {
        let cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath:IndexPath = self.orderTable.indexPath(for: cell)!
        currentIndexPath = indexPath
        let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
        currentProduct = DataManager.GetProductForProductId(orderItem.product_id!)
        showSizePickers(sender)
    }
    
    func btnProcutQuantityClicked(_ sender:UIButton)
    {
        let cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath:IndexPath = self.orderTable.indexPath(for: cell)!
        currentIndexPath = indexPath
        let orderItem:Order_items = orderItems![indexPath.row] as! Order_items
        currentProduct = DataManager.GetProductForProductId(orderItem.product_id!)
        showQuantityPickers(sender, orderQuantity: orderItem.quantity!)
    }
    
    func btnCopyProductClicked(_ sender:UIButton)
    {
        currentIndexPath = self.selectedIndexPath
        let orderItem:Order_items = orderItems![currentIndexPath.row] as! Order_items

        currentProduct = DataManager.GetProductForProductId(orderItem.product_id!)
        
        
        let orderItemCopy:Order_items = DataManager.initializeSize_order_items()
        orderItemCopy.id = "\(Date ())"
        orderItemCopy.order_id = self.appDelegate.getCurrentOrderId()
        orderItemCopy.product_id = (currentProduct?.id?.stringValue)!
        orderItemCopy.color = (orderItem.color)!
        orderItemCopy.size = (orderItem.size)!
        orderItemCopy.quantity = (orderItem.quantity)!
        orderItemCopy.price = orderItem.price
        orderItemCopy.style = (orderItem.style)!
        orderItemCopy.note = "\((orderItem.note)!)"
        orderItemCopy.unit_price = currentProduct?.price
        DataManager.SaveOrderItems(orderItemCopy)
        
        if(self.appDelegate.getCurrentOrderId() != nil){
            
            order = DataManager.GetCurrentOrderForOrderId(self.appDelegate.getCurrentOrderId()!)
            orderItems = DataManager.GetAllOrderItemsForOrderId((order?.id)!)
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)
            self.labelTotalOrder.text = "Total: \(totalCount)"
        }
        self.orderTable.reloadData()
        self.orderTable.scrollToNearestSelectedRow(at: UITableViewScrollPosition.bottom, animated: true)
        
    }

    func btnDeleteProductClicked(_ sender:UIButton){
        currentIndexPath = self.selectedIndexPath
        let orderItem:Order_items = orderItems![currentIndexPath.row] as! Order_items
        
        DataManager.deleteOrderItems(orderItem)
        if(self.appDelegate.getCurrentOrderId() != nil){
            
            order = DataManager.GetCurrentOrderForOrderId(self.appDelegate.getCurrentOrderId()!)
            orderItems = DataManager.GetAllOrderItemsForOrderId((order?.id)!)
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)
            self.labelTotalOrder.text = "Total: \(totalCount)"
        }
        self.orderTable.reloadData()
        self.orderTable.scrollToNearestSelectedRow(at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    func handleLongPress(_ longPressGesture:UILongPressGestureRecognizer) {
        
        let p = longPressGesture.location(in: self.orderTable)
        let indexPath = self.orderTable.indexPathForRow(at: p)
        
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {
            print("Long press on row, at \(indexPath!.row)")
            if(self.selectedIndexPath == indexPath){
                let cell :OrderTableViewCell = self.orderTable.cellForRow(at: indexPath!) as! OrderTableViewCell;
                cell.blurView.isHidden = true
                self.selectedIndexPath = nil
            }else{
                if((self.selectedIndexPath == nil)){
                    let cell :OrderTableViewCell = self.orderTable.cellForRow(at: indexPath!) as! OrderTableViewCell;
                    cell.blurView.isHidden = false
                    self.selectedIndexPath = indexPath
                }else{
                    
                    let cell :OrderTableViewCell = self.orderTable.cellForRow(at: indexPath!) as! OrderTableViewCell;
                    cell.blurView.isHidden = false
                    self.selectedIndexPath = indexPath

                }
                
            }
            
            
        }
        
    }
    
    
    
    

    @IBAction func billToAction(_ sender: AnyObject) {
        if( order != nil){
            self.addressController.isShipAddress = false
            self.addressController.selectedOrder = order
            showAddress("Bill To")
        }
        
    }
    
    @IBAction func shipToAction(_ sender: AnyObject) {
        if( order != nil){
            self.addressController.isShipAddress = true
            self.addressController.selectedOrder = order
            showAddress("Ship To")
        }
       

    }
    
    @IBAction func sameAsBillAction(_ sender: UIButton) {
        if sameAsBill {
            sameAsBill = false
            imageSameAsBill.image = UIImage(named:  "check_off")
        }else{
            sameAsBill = true
            imageSameAsBill.image = UIImage(named:  "check_on")

            if(order?.bill_to?.characters.count > 0){
                order!.ship_to = order!.bill_to!
                DataManager.UpdateOrder(order!)
            }

        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let txt = textField as? SRKDateTimeBox {
            txt.delegateForDateTimeBox = self
            txt.showOptions()
            return false
        }
        return true
    }
    
    //MARK:- SRKDateTimeBoxDelegate
    
    func dateTimeBox(_ textField:SRKDateTimeBox, didSelectDate date:Date) {
        let df = DateFormatter()
        if textField == self.txtOrderDate {
            df.dateFormat = "dd-MMM-yyyy"
            self.txtOrderDate.text = df.string(from: date)
            order?.order_date = date
        } else if textField == self.txtStartDate {
            df.dateFormat = "dd-MMM-yyyy"
            self.txtStartDate.text = df.string(from: date)
            order?.start_date = date

        }else if textField == self.txtCompDate {
            df.dateFormat = "dd-MMM-yyyy"
            self.txtCompDate.text = df.string(from: date)
            order?.complition_date = date
        }
    }
    
    func dateTimeBoxType(_ textField:SRKDateTimeBox) -> UIDatePickerMode {
        if textField == self.txtOrderDate {
            return UIDatePickerMode.date
        } else if textField == self.txtStartDate {
            return UIDatePickerMode.date
        } else if textField == self.txtCompDate {
            return UIDatePickerMode.date
        }
        return UIDatePickerMode.date
    }
    
    func dateTimeBoxMinimumDate(_ textField:SRKDateTimeBox) -> Date? {
        return nil
    }
    
    func dateTimeBoxMaximumDate(_ textField:SRKDateTimeBox) -> Date? {
        return nil
    }
    
    func dateTimeBoxPresentingViewController(_ textField:SRKDateTimeBox) -> UIViewController {
        return self
    }
    
    func dateTimeBoxRectFromWhereToPresent(_ textField:SRKDateTimeBox) -> CGRect {
        let y_pos:CGFloat! = self.viewOrderInput.frame.origin.y
        let x_pos:CGFloat! = self.viewOrderInput.frame.origin.x
        
        return CGRect(x: x_pos+textField.frame.origin.x, y: y_pos+textField.frame.origin.y, width: textField.frame.size.width, height: textField.frame.size.height)
    }
    
    func dateTimeBoxFromBarButton(_ textField:SRKDateTimeBox) -> UIBarButtonItem? {
        return nil
    }
    
    func dateTimeBoxTintColor(_ textField:SRKDateTimeBox) -> UIColor {
        return UIColor.black
    }
    
    func dateTimeBoxToolbarColor(_ textField:SRKDateTimeBox) -> UIColor {
        return UIColor.white
    }
    
    func dateTimeBoxDidTappedCancel(_ textField:SRKDateTimeBox) {
        textField.text = ""
    }
    
    func dateTimeBoxDidTappedDone(_ textField:SRKDateTimeBox) {
        print("Let's do some action here")
    }
    
    //MARK:- Textview delegate
    
    func textViewShouldBeginEditing(_ aTextView: UITextView) -> Bool{
        let cell:UITableViewCell = aTextView.superview?.superview as! UITableViewCell
        let indexPath:IndexPath = self.orderTable.indexPath(for: cell)!
        currentIndexPath = indexPath
        currentOrderItem = orderItems![indexPath.row] as! Order_items
        self.showOrderNote = false

        showNote("PRODUCT NOTES")
        return false
    }
    
    @IBAction func actionAddProducts(_ sender: AnyObject) {
        let controller:ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
//        self.navigationController?.popToViewController(appDelegate.menuViewController!, animated: true)
    }

    
    @IBAction func actionCompare(_ sender: AnyObject) {
//        let alert = UIAlertController(title: "Coming soon!!", message: "We are currently working on this page", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        let controller:CoparisonViewController = CoparisonViewController(nibName: "CoparisonViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionOrderNotes(_ sender: AnyObject) {
        self.showOrderNote = true
        showNote("ORDER NOTES")

    }
    
    @IBAction func actionSubmit(_ sender: AnyObject) {
        var isCorrectInput = true
        var errorText : String = ""
        
        if(self.txtPO.text?.characters.count == 0){
            isCorrectInput = false
            errorText = "Please enter PO"
        }
//        if(self.txtContact.text?.characters.count == 0){
//            isCorrectInput = false
//            errorText = "Please enter Contact"
//        }
//        if(self.txtPhone.text?.characters.count == 0){
//            isCorrectInput = false
//            errorText = "Please enter Phone number"
//        }
//        if(self.txtFax.text?.characters.count == 0){
//            isCorrectInput = false
//            errorText = "Please enter FAX"
//        }
        if(self.txtEmail.text?.characters.count == 0){
            isCorrectInput = false
            errorText = "Please enter email"
        }
        
        if(self.order?.ship_to?.characters.count <= 0){
            isCorrectInput = false
            errorText = "Please enter Shipping Address"
            
        }
//        if(self.order?.bill_to?.characters.count <= 0){
//            isCorrectInput = false
//            errorText = "Please enter Billing Address"
//            
//        }
//        if(self.txtcatelog.text?.characters.count == 0){
//            isCorrectInput = false
//            errorText = "Please enter Catalog number"
//        }
        if( isCorrectInput == true ){
            
            let orderItems : NSArray = DataManager.GetAllOrderItemsForOrderId((order!.id)!)
            var orderItemInput = true
            for index in 0...orderItems.count-1 {
                
                let orderItem:Order_items = orderItems[index] as! Order_items
                if orderItem.color?.characters.count <= 0 {
                    orderItemInput = false
                }
                if orderItem.size?.characters.count <= 0 {
                    orderItemInput = false

                }
                if orderItem.quantity?.characters.count <= 0 {
                    orderItemInput = false

                }
            }
            
            if orderItemInput == false {
                let alert = UIAlertController(title: "Error", message: "Please provide Size, Quantity, Color for each items", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if(self.order?.image != nil){
                self.order?.order_submitted = NSNumber(value: true as Bool)
                self.order?.order_editable = NSNumber(value: true as Bool)
                
                if(self.appDelegate.selectedStore != nil){
                    self.order?.store_id = (self.appDelegate.selectedStore?.account_number)!
                }
                if(self.appDelegate.currentSalesMan != nil){
                    self.order?.salesman_id = (self.appDelegate.currentSalesMan?.id)!
                }
                
                self.order?.po = (self.txtPO.text)!
                self.order?.contact = (self.txtContact.text)!
                self.order?.phone = (self.txtPhone.text)!
                self.order?.fax = (self.txtFax.text)!
                self.order?.email = (self.txtEmail.text)!
                self.order?.catelouge = (self.txtcatelog.text)!
                let df = DateFormatter()
                df.dateFormat = "dd-MMM-yyyy"
                self.order?.order_date = df.date(from: self.txtOrderDate.text!)
                self.order?.complition_date = df.date(from: self.txtCompDate.text!)
                self.order?.start_date = df.date(from: self.txtStartDate.text!)
                DataManager.UpdateOrder(self.order!)
                if(self.appDelegate.getCurrentOrderId() != nil){
                    self.appDelegate.saveCurrentOrder()
                }
                self.navigationController?.popToRootViewController(animated: true)

            }else{
                showSignature()

            }

        }else{
            let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
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
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        return [UIInterfaceOrientationMask.portrait]
    }

}
