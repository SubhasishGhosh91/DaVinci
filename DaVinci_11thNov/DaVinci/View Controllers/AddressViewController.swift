//
//  AddressViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/2/16.
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


class AddressViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var addressLine1: UITextField!
    
    @IBOutlet weak var addressLine2: UITextField!
    
    @IBOutlet weak var addressLine3: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var state: UITextField!
    
    @IBOutlet weak var zip: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var selectedOrder:Orders!
    
    var isShipAddress = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: 30)
        
        self.addressLine1.leftView = leftView
        self.addressLine1.leftViewMode = UITextFieldViewMode.always
        self.addressLine1.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        self.addressLine1.layer.borderWidth = 2.0
        
        updateTextFieldDesign(self.city)
        updateTextFieldDesign(self.addressLine2)
        updateTextFieldDesign(self.addressLine3)
        updateTextFieldDesign(self.state)
        updateTextFieldDesign(self.zip)
        
        self.btnSubmit.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.btnSubmit.layer.borderWidth = 2.0
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTextFieldDesign (_ textField:UITextField){
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: 30)
        
        textField.leftView = leftView
        textField.leftViewMode = UITextFieldViewMode.always
        textField.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        textField.layer.borderWidth = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addressLine1.text = ""
        self.addressLine2.text = ""
        self.addressLine3.text = ""
        if (isShipAddress ){
            let address =  AddressFormatter.splitAddressToAddresslines(selectedOrder.ship_to!)
            if(address?.count > 0){
                self.addressLine1.text =  "\((address![0] as? String)!)"
            }
            if(address?.count > 1){
                self.addressLine2.text =  "\((address![1] as? String)!)"
            }
            if(address?.count > 2){
                self.addressLine3.text =  "\((address![2] as? String)!)"
            }
            
            self.city.text = "\((AddressFormatter.splitAddressToCity(selectedOrder.ship_to!)!))"
            self.state.text = "\((AddressFormatter.splitAddressToState(selectedOrder.ship_to!)!))"
            self.zip.text = "\((AddressFormatter.splitAddressToZip(selectedOrder.ship_to!)!))"
            
            
        }else{
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
    
    @IBAction func submitAction(_ sender: AnyObject) {
        let address:String = AddressFormatter.getAddressFromAddresLine(self.addressLine1.text!, addressline2: self.addressLine2.text!, addressline3: self.addressLine3.text!, city: self.city.text!, state: self.state.text!, zip: self.zip.text!)
        if (isShipAddress ){
            selectedOrder.ship_to = address
 
        }else{
            selectedOrder.bill_to = address

        }
        DataManager.UpdateOrder(selectedOrder)
        self.dismiss(animated: true, completion: nil)
    }

}
