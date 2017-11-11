//
//  MenuViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/4/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
import SRKControls

class MenuViewController: UIViewController ,UITextFieldDelegate,SRKComboBoxDelegate{
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    @IBOutlet weak var viewDropDownHolder: UIView!
    @IBOutlet weak var textFieldDropDown: UITextField!
    @IBOutlet weak var viewSlide: UIView!
    @IBOutlet weak var viewProducts: UIView!
    @IBOutlet weak var viewPlaceorder: UIView!
    @IBOutlet weak var labelOrderNumber: UILabel!
    var appDelegate:AppDelegate?

    @IBOutlet var exitButton: UIButton!
    @IBOutlet weak var accountCombo: SRKComboBox!
    let arrayForComboBox = ["Sagar", "Sagar R. Kothari", "Kothari", "sag333ar", "sag333ar.github.io", "samurai", "jack", "cartoon", "network"]
    var collectionPickerController:CollectionPickerViewController!
    var collectionPopover: UIPopoverPresentationController!
    var storePickerController:StorePickerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="DASHBOARD"
        
        let barButton = UIBarButtonItem(customView: self.exitButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.menuViewController = self
        
        self.viewDropDownHolder.layer.cornerRadius = 10.0
        self.viewDropDownHolder.clipsToBounds = true
        
        self.viewSlide.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        self.viewSlide.layer.borderWidth = 2.0
        
        self.viewProducts.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        self.viewProducts.layer.borderWidth = 2.0
        
        self.viewPlaceorder.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        self.viewPlaceorder.layer.borderWidth = 2.0
        if(appDelegate?.selectedStore != nil){
            self.labelShopName.text = "\((self.appDelegate?.selectedStore?.name)!)"
            self.labelShopName.adjustsFontSizeToFitWidth = true

            if(self.appDelegate!.selectedStore?.address1 != nil && self.appDelegate!.selectedStore?.address2 != nil){
//                var address:String = AddressFormatter.getAddressFromAddresLine((self.appDelegate!.selectedStore?.address1!)!, addressline2: (self.appDelegate!.selectedStore?.address2!)!, addressline3: "", city: (self.appDelegate!.selectedStore?.city!)!, state: (self.appDelegate!.selectedStore?.state!)!, zip: (self.appDelegate!.selectedStore?.zip!)!)
                let address:String = (self.appDelegate!.selectedStore?.address1!)! + " " + (self.appDelegate!.selectedStore?.address2!)! + "\n" + (self.appDelegate!.selectedStore?.city!)! + ", " + (self.appDelegate!.selectedStore?.state!)! + " "+(self.appDelegate!.selectedStore?.zip!)!
                self.labelShopAddress.text = "\(address)"
                self.labelShopAddress.adjustsFontSizeToFitWidth = true
            }else{
                self.labelShopAddress.text = ""
            }

        }
        
        self.collectionPickerController = CollectionPickerViewController(nibName: "CollectionPickerViewController", bundle: nil)
        self.collectionPickerController.completionHandler = {
            (selectedObject:Collections) -> Void in
            if self.appDelegate?.selectedCollection != nil && self.appDelegate?.selectedCollection?.id != selectedObject.id{
                OperationQueue.main.addOperation {
                    let actionSheetController: UIAlertController = UIAlertController(title: "Warning!", message: "When you change collections, the cart will empty. Would you like to change collections?", preferredStyle: .alert)
                    actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

                    let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                        self.appDelegate?.removeFromCurrentOrder()
                        self.labelOrderNumber.text = "\(0)"
                        self.accountCombo.text = selectedObject.name
                        self.appDelegate?.selectedCollection = selectedObject
                        
                    }
                    actionSheetController.addAction(nextAction)
                    
                    self.present(actionSheetController, animated: true, completion: nil)
                }
                
                
                
            

            }else{
                self.accountCombo.text = selectedObject.name
                self.appDelegate?.selectedCollection = selectedObject
            }
           

        }
        
        self.storePickerController = StorePickerViewController(nibName: "StorePickerViewController", bundle: nil)
        self.storePickerController.completionHandler = {
            (selectedObject:Store) -> Void in
            self.accountCombo.text = selectedObject.name
            self.appDelegate?.selectedStore = selectedObject
        }

        self.accountCombo.text = (self.appDelegate?.selectedCollection?.name)!

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if(self.appDelegate!.getCurrentOrderId() != nil){
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)

            self.labelOrderNumber.text = "\(totalCount)"
            
        }else{
            self.labelOrderNumber.text = "0"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func collectionAction(_ sender: AnyObject) {
        showAccountPickers(textFieldDropDown)

    }
    func showAccountPickers(_ sender:AnyObject){
        
        self.collectionPickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.collectionPopover = self.collectionPickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 360,height: 250)
        
        self.collectionPickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.collectionPopover.sourceView = viewForSource
        self.collectionPopover.sourceRect = viewForSource.bounds;
        
        self.collectionPopover.permittedArrowDirections = UIPopoverArrowDirection.up/*(rawValue: 0)*/
        
        present(self.collectionPickerController,
                              animated: true, completion:nil)
        
    }
    
    func showStorePickers(_ sender:AnyObject){
        
        self.storePickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        self.collectionPopover = self.storePickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 360,height: 250)
        
        self.storePickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.collectionPopover.sourceView = viewForSource
        self.collectionPopover.sourceRect = viewForSource.bounds;
        
        self.collectionPopover.permittedArrowDirections = UIPopoverArrowDirection.up/*(rawValue: 0)*/
        
        present(self.storePickerController,
                              animated: true, completion:nil)
        
    }

    
    // MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let txt = textField as? SRKComboBox {
            showAccountPickers(txt)

            return false
        }
        return true
    }
    
    // MARK:- SRKComboBoxDelegate
    
    func comboBox(_ textField:SRKComboBox, didSelectRow row:Int) {
        if textField == self.accountCombo {
            self.accountCombo.text = self.arrayForComboBox[row]
        }
    }
    
    func comboBoxNumberOfRows(_ textField:SRKComboBox) -> Int {
        if textField == self.accountCombo {
            return self.arrayForComboBox.count
        } else {
            return 0
        }
    }
    
    func comboBox(_ textField:SRKComboBox, textForRow row:Int) -> String {
        if textField == self.accountCombo {
            return self.arrayForComboBox[row]
        } else {
            return ""
        }
    }
    
    func comboBoxPresentingViewController(_ textField:SRKComboBox) -> UIViewController {
        return self
    }
    
    func comboBoxRectFromWhereToPresent(_ textField:SRKComboBox) -> CGRect {
        let y_pos:CGFloat! = self.viewDropDownHolder.frame.origin.y
        let x_pos:CGFloat! = self.viewDropDownHolder.frame.origin.x
        
        return CGRect(x: x_pos+textField.frame.origin.x, y: y_pos+textField.frame.origin.y, width: textField.frame.size.width, height: textField.frame.size.height)
    }
    
    func comboBoxFromBarButton(_ textField:SRKComboBox) -> UIBarButtonItem? {
        return nil
    }
    
    func comboBoxTintColor(_ textField:SRKComboBox) -> UIColor {
        return UIColor.black
    }
    
    func comboBoxToolbarColor(_ textField:SRKComboBox) -> UIColor {
        return UIColor.white
    }
    
    func comboBoxDidTappedCancel(_ textField:SRKComboBox) {
        textField.text = ""
    }
    
    func comboBoxDidTappedDone(_ textField:SRKComboBox) {
        print("Let's do some action here")
    }

    

    @IBAction func slideAction(_ sender: AnyObject) {
//        let alert = UIAlertController(title: "Coming soon!!", message: "We are currently working on this page", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        let controller:SlideShowViewController = SlideShowViewController(nibName: "SlideShowViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true);
    }
    
    @IBAction func productAction(_ sender: AnyObject) {
        let controller:ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func orderAction(_ sender: AnyObject) {
        let controller:OrderViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true);
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
    
    @IBAction func exitAction(_ sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Warning!", message: "Leaving this account number will restart the order. Are you sure you want to leave?", preferredStyle: .alert)
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            self.appDelegate?.removeFromCurrentOrder()

            self.navigationController?.popToRootViewController(animated: true)

            
        }
        
        actionSheetController.addAction(nextAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
}
