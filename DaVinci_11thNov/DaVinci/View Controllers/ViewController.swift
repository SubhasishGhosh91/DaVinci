//
//  ViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/1/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
import SRKControls
import CoreData
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


class Downloader {
    
    class func downloadImageWithURL(_ url:String) -> Data! {
        
        let data = try? Data(contentsOf: URL(string: url)!)
        return data/*UIImage(data: data!)*/
    }
}

class ViewController: BaseViewController ,UITextFieldDelegate,SRKComboBoxDelegate        {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageAcNumber: UIImageView!
    @IBOutlet weak var viewCredentialHolder: UIView!
    @IBOutlet weak var imageCollection: UIImageView!
    @IBOutlet weak var textFieldAccount: UITextField!
    @IBOutlet weak var textFieldCollection: SRKComboBox!
    var queue = OperationQueue()
    var appDelegate:AppDelegate?
    var arrayForComboBox:NSArray = []
    var collectionPickerController:CollectionPickerViewController!
    var collectionPopover: UIPopoverPresentationController!
    var inputTextField: UITextField?
    var videoFiles:NSMutableArray?
    var videoIndex = 0
    var salesmanEmail : String?
    var userSelectedCollection:Collections?
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        arrayForComboBox = DataManager.GetAllCollections() as! [Collections]
        self.viewCredentialHolder.layer.cornerRadius = 10.0
        self.viewCredentialHolder.clipsToBounds = true
        self.navigationItem.title="EXIT"
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.collectionPickerController = CollectionPickerViewController(nibName: "CollectionPickerViewController", bundle: nil)
        
        self.collectionPickerController.completionHandler = {
            (selectedObject:Collections ) -> Void in
            self.textFieldCollection.text = selectedObject.name
            self.appDelegate?.selectedCollection = selectedObject
            self.userSelectedCollection = selectedObject
        }
        self.textFieldAccount.autocorrectionType = UITextAutocorrectionType.no
        self.textFieldAccount.keyboardType = UIKeyboardType.numberPad
        queue = OperationQueue()
        videoFiles = NSMutableArray()
        self.progressView.progress = 0
        self.progressView.isHidden = true




    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.showRegistrationAlert()

       
        
        
        
       
        self.textFieldCollection.text = ""
        self.textFieldAccount.text = ""
        

    }
    
    func showNetworkAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
       
    }
    
    func showRegistrationAlert(){
        
        if(self.appDelegate!.getCurrentSalesmanId() == nil){
            
            if Reachability.isConnectedToNetwork() == true {
            } else {
                
                showNetworkAlert()
                return
                
            }
            
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Register", message: "Please enter your mail id to register this device", preferredStyle: .alert)
            let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in

                if self.inputTextField?.text?.characters.count == 0 {
                    self.inputTextField?.text = "brandon@emmebridal.com"

//                    self.showRegistrationAlert()

                }
                
                self.startActivity(self.view!)
                
                
                var UUIDValue:String = UIDevice.current.identifierForVendor!.uuidString
                UUIDValue = UUIDValue.replacingOccurrences(of: "-", with:"")
                
                let urlString:String = "https://davincibridal.com/salesapp/action/set_salesman_device/"
                var request = URLRequest(url: URL(string: urlString)!)
                request.httpMethod = "POST"
                let postString = "email=\((self.inputTextField?.text)!)&device_id=\(UUIDValue)"
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
                        let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                        print("json value: \(dict)")
                        let status : String = dict["status"] as! String
                        
                        if(status == "ok") {
                            self.salesmanEmail  = (self.inputTextField?.text)!
                            
                        }else{
                            abort()
                        }
                        
                        DispatchQueue.main.async {
                            self.stopActivity(self.view)
                        }
                        
                        
                    }
                    catch {
                        print("json error: \(error)")
                    }
                    
                }) 
                task.resume()
                
            }
            actionSheetController.addAction(nextAction)
            actionSheetController.addTextField { textField -> Void in
                self.inputTextField = textField
            }
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
//    func addImageUrlToDownloadQueue(imageUrl:String,imageId:String){
//        print("\(imageUrl)")
//        let operation1 = NSBlockOperation(block: {
//            let imageId = imageId
//            let data = Downloader.downloadImageWithURL(imageUrl)
//            NSOperationQueue.mainQueue().addOperationWithBlock({
//                //"Could not fetch \(error), \(error.userInfo)"
//                if( data != nil){
//                    if data.length > 0 {
//                        let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("\(imageId)")
//                        if filename.characters.count > 0 {
//                            data.writeToFile(filename, atomically: true)
//                            let image:Image = DataManager.initializeImage()
//                            image.sourceurl = imageUrl
//                            image.fileurl = imageId
//                            DataManager.SaveImageUrl(image)
//                            
//                        }
//                    }
//
//                }
//                
//                if(self.queue.operationCount == 0) {
//                    print ("Image download completed")
//                    if self.videoFiles?.count>self.videoIndex {
//                        self.downloadVideoUrlAtIndex(self.videoIndex)
//                        self.videoIndex = self.videoIndex+1
//                    }else{
//                        print ("No video found")
//                        self.stopActivity(self.view!)
//
//                    }
//
//                }
//            })
//        })
//        
//        operation1.completionBlock = {
//            print("Operation 1 completed, cancelled:\(operation1.cancelled)")
//        }
//        queue.addOperation(operation1)
//    }
    
//    func addImageUrlToDownloadQueue(imageUrl:String,imageId:String){
//        print("\(imageUrl)")
//        let operation1 = NSBlockOperation(block: {
//            let imageId = imageId
//            let data = Downloader.downloadImageWithURL(imageUrl)
//            NSOperationQueue.mainQueue().addOperationWithBlock({
//                //"Could not fetch \(error), \(error.userInfo)"
//                if( data != nil){
//                    if data.length > 0 {
//                        let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("\(imageId)")
//                        if filename.characters.count > 0 {
//                            data.writeToFile(filename, atomically: true)
//                            let image:Image = DataManager.initializeImage()
//                            image.sourceurl = imageUrl
//                            image.fileurl = imageId
//                            DataManager.SaveImageUrl(image)
//                            
//                        }
//                    }
//                    
//                }
//                
//                if(self.queue.operationCount == 0) {
//                    print ("Image download completed")
//                    if self.videoFiles?.count>self.videoIndex {
//                        self.downloadVideoUrlAtIndex(self.videoIndex)
//                        self.videoIndex = self.videoIndex+1
//                    }else{
//                        print ("No video found")
//                        self.stopActivity(self.view!)
//                        
//                    }
//                    
//                }
//            })
//        })
//        
//        operation1.completionBlock = {
//            print("Operation 1 completed, cancelled:\(operation1.cancelled)")
//        }
//        queue.addOperation(operation1)
//    }
    
    func downloadVideoUrlAtIndex(_ index:NSInteger){
        let video : String = self.videoFiles![index] as! String
        print ("File name \(video)")
        let videoFieldName = (video as NSString).lastPathComponent
        let filenameExisting = self.getDocumentsDirectory().appendingPathComponent("\(videoFieldName)")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filenameExisting){
            if filenameExisting.characters.count > 0 {
                print ("Existing file name \(videoFieldName)")

                let image:Image = DataManager.initializeImage()
                image.sourceurl = videoFieldName
                image.fileurl = filenameExisting
                DataManager.SaveImageUrl(image)
            }
            OperationQueue.main.addOperation({
                if self.videoFiles?.count>self.videoIndex {
                    self.downloadVideoUrlAtIndex(self.videoIndex)
                    self.videoIndex = self.videoIndex+1
                    let div = Double(self.videoIndex) / Double((self.videoFiles?.count)!)
                    self.progressView.progress = Float(div )
                }else{
                    print ("Video download completed")
                    self.stopActivity(self.view!)
                    self.progressView.progress = 1
                    self.progressView.isHidden = true
                    
                }
            })
        } else {
            let safeURL = video.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let request = URLRequest(url: URL(string: safeURL)!)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil && data != nil else {                                                                                  print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                if data!.count > 0 {
                    let filename = self.getDocumentsDirectory().appendingPathComponent("\(videoFieldName)")
                    if filename.characters.count > 0 {
                        print ("Downloaded file name \(videoFieldName)")

                        try? data!.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                        let image:Image = DataManager.initializeImage()
                        image.sourceurl = videoFieldName
                        image.fileurl = filename
                        DataManager.SaveImageUrl(image)
                    }
                }
                
                OperationQueue.main.addOperation({
                    if self.videoFiles?.count>self.videoIndex {
                        self.downloadVideoUrlAtIndex(self.videoIndex)
                        self.videoIndex = self.videoIndex+1
                        let div = Double(self.videoIndex) / Double((self.videoFiles?.count)!)
                        self.progressView.progress = Float(div )
                    }else{
                        print ("Video download completed")
                        self.stopActivity(self.view!)
                        self.progressView.progress = 1
                        self.progressView.isHidden = true
                        
                    }
                })
            }) 
            task.resume()
        }
        
        
        
       
    }
    
    
    
//    func getDocumentsDirectory() -> NSString {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
    
    
    func showAccountPickers(_ sender:AnyObject){
        
        self.collectionPickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.collectionPopover = self.collectionPickerController.popoverPresentationController!
        
        var expected:CGSize!
        
        expected = CGSize(width: 450,height: 250)
        
        self.collectionPickerController.preferredContentSize   = expected
        
        let viewForSource = sender as! UIView
        self.collectionPopover.sourceView = viewForSource
        self.collectionPopover.sourceRect = viewForSource.bounds;
        
        self.collectionPopover.permittedArrowDirections = UIPopoverArrowDirection.up/*(rawValue: 0)*/
        
        present(self.collectionPickerController,
                              animated: true, completion:nil)
        
    }

    @IBAction func collectionAction(_ sender: AnyObject) {
        if DataManager.GetAllCollections().count > 0 {
            showAccountPickers(textFieldCollection)
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Please click \"SYNC\" before continue", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func enterAction(_ sender: AnyObject) {
        
//        //Use image name from bundle to create NSData
//        let image : UIImage = UIImage(named:"check_on")!
//        //Now use image to create into NSData format
//        let imageData:NSData = UIImagePNGRepresentation(image)!
//
//        
//        //Now use image to create into NSData format
//        let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//        print("\(strBase64)")
//        
//        return
        
        if(self.appDelegate?.selectedCollection != nil ){
            
            let store:Store? = DataManager.GetStoreForStoreAcNumber(self.textFieldAccount.text!.trimmingCharacters(in: CharacterSet.whitespaces))
            
            if (store != nil || self.textFieldAccount.text == "0") {
                self.textFieldAccount.resignFirstResponder()
                self.textFieldCollection.resignFirstResponder()
                let controller:MenuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
                if (store != nil){
                    appDelegate?.selectedStore = store
                    
                }
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }else if(self.appDelegate?.selectedCollection == nil && self.userSelectedCollection != nil){
            self.appDelegate?.selectedCollection = self.userSelectedCollection
            let store:Store? = DataManager.GetStoreForStoreAcNumber(self.textFieldAccount.text!.trimmingCharacters(in: CharacterSet.whitespaces))
            
            if (store != nil || self.textFieldAccount.text == "0") {
                self.textFieldAccount.resignFirstResponder()
                self.textFieldCollection.resignFirstResponder()
                let controller:MenuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
                if (store != nil){
                    appDelegate?.selectedStore = store
                    
                }
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
       
        
    }
    
    @IBAction func orderAction(_ sender: AnyObject) {
//        let alert = UIAlertController(title: "Coming soon!!", message: "We are currently working on this page", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        let controller:DashBoardViewController = DashBoardViewController(nibName: "DashBoardViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let txt = textField as? SRKComboBox {
            if DataManager.GetAllCollections().count > 0 {
                showAccountPickers(txt)

            }else{
                let alert = UIAlertController(title: "Error", message: "Please click \"SYNC\" before continue", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.collectionAction(self.enterButton);
        return true
    }
    
    // MARK:- SRKComboBoxDelegate
    
    func comboBox(_ textField:SRKComboBox, didSelectRow row:Int) {
        if textField == self.textFieldCollection {
            let collection:Collections = self.arrayForComboBox[row] as! Collections
            self.textFieldCollection.text = collection.name!
        }
    }
    
    func comboBoxNumberOfRows(_ textField:SRKComboBox) -> Int {
        if textField == self.textFieldCollection {
            return self.arrayForComboBox.count
        } else {
            return 0
        }
    }
    
    func comboBox(_ textField:SRKComboBox, textForRow row:Int) -> String {
        if textField == self.textFieldCollection {
            let collection:Collections = self.arrayForComboBox[row] as! Collections
            return collection.name!
        } else {
            return ""
        }
    }
    
    func comboBoxPresentingViewController(_ textField:SRKComboBox) -> UIViewController {
        return self
    }
    
    func comboBoxRectFromWhereToPresent(_ textField:SRKComboBox) -> CGRect {
        let y_pos:CGFloat! = self.viewCredentialHolder.frame.origin.y
        let x_pos:CGFloat! = self.viewCredentialHolder.frame.origin.x

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

    override var shouldAutorotate : Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown) {
            
            return false
        }
        else {
            return true
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return [UIInterfaceOrientationMask.portrait ,UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    @IBAction func syncData(_ sender: AnyObject) {
        
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

        let task = URLSession.shared.dataTask(with: URL(string: "https://davincibridal.com/salesapp/action/get_table_data")!, completionHandler: { (data, response, error) -> Void in
            do{
                DataManager.clearAll()
                self.textFieldCollection.text = ""
                self.textFieldAccount.text = ""
                let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                for (key, value) in dict {
                    
                    if (key=="store_date"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let store_date:Store_date = DataManager.initializeStoreDate()
                            store_date.start_date = self.getDateFromString2(itemDict["start_date"] as! String)
                            store_date.end_date = self.getDateFromString2(itemDict["end_date"] as! String)
                            store_date.completion_date = self.getDateFromString2(itemDict["completion_date"] as! String)
//                            DataManager.SaveStoreDate(store_date)
                        }
                    }
                    
                    if (key=="collections"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let collection:Collections = DataManager.initializeCollections()
                            collection.id = itemDict["id"] as? String
                            collection.name = itemDict["name"] as? String
                            collection.created_on = self.getDateFromString(itemDict["created_on"] as! String)
//                            DataManager.SaveCollection(collection)
                        }
                    }
                    if (key=="pricing_upcharge"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let upcharge:Pricing_upcharge = DataManager.initializePricingUpcharge()
                            upcharge.id = itemDict["id"] as? String
                            upcharge.category_id = itemDict["category_id"] as? String
                            upcharge.product_size = itemDict["size"] as? String
                            upcharge.price = NSNumber(value: ((itemDict["price"] as AnyObject).floatValue)! as Float)
//                            DataManager.SavePricingUpcharge(upcharge)
                        }
                    }
                    if (key=="salesman"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let salesMan:Salesman = DataManager.initializeSalesMan()
                            salesMan.name = (itemDict["name"]! as AnyObject).uppercased.trimmingCharacters(in: CharacterSet.whitespaces) as String
                            salesMan.id = itemDict["id"] as? String
                            salesMan.email = (itemDict["email"] as? String)?.lowercased()
                            salesMan.contact = itemDict["contact"] as? String
                            salesMan.phone = itemDict["phone"] as? String
                            salesMan.fax = itemDict["fax"] as? String
                            salesMan.is_active = NSNumber(value: ((itemDict["fax"] as AnyObject).intValue)! as Int)
                            salesMan.created_on = self.getDateFromString(itemDict["created_on"] as! String)
//                            DataManager.SaveSalesman(salesMan)
                            
                            
                            
                        }
                    }
                    if (key=="products"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let product:Products = DataManager.initializeProducts()
                            if((itemDict["is_sellable"] as AnyObject).intValue == 1){
                                product.id = NSNumber(value: ((itemDict["id"] as AnyObject).intValue)! as Int)
                                product.collection_id = itemDict["collection_id"] as? String
                                product.style = itemDict["style"] as? String
                                product.color = itemDict["color"] as? String
                                product.fabric = itemDict["fabric"] as? String
                                product.size = itemDict["size"] as? String
                                product.price = NSNumber(value: ((itemDict["price"] as AnyObject).floatValue)! as Float)
                                product.is_sellable = NSNumber(value: ((itemDict["is_sellable"] as AnyObject).intValue)! as Int)
                                print("images -> \(itemDict["images"] ?? "")")
                                
                                if( itemDict["images"] != nil){
                                    product.images = itemDict["images"] as? String
                                    
                                    if let value = (product.images?.components(separatedBy: ",")){
                                        let imageArray : NSArray = value as NSArray
                                        
                                        for imageitem in imageArray{
                                            let item : String = imageitem as! String
                                            let theFileName = (item as NSString).lastPathComponent
                                            print ("File details : \(theFileName) && \(item)")
                                            self.videoFiles?.add(item)
                                            
                                        }
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                product.created_on = self.getDateFromString(itemDict["created_on"] as! String)
                                product.primary_image = itemDict["primary_image"] as? String
                                let primaryImage : String = (product.primary_image)!
                                self.videoFiles?.add(primaryImage)

                                if itemDict["video"] as? String != nil {
                                    print("Video start")
                                    product.video = itemDict["video"] as? String
                                    print("Video \(itemDict["video"] ?? "")")
                                    self.videoFiles?.add((product.video)!)
                                }
                            }else{
                                product.id = NSNumber(value: ((itemDict["id"] as AnyObject).intValue)! as Int)
                                product.collection_id = itemDict["collection_id"] as? String
                                product.style = itemDict["style"] as? String
                                product.color = ""
                                product.fabric = ""
                                product.size = ""
                                product.price = 0
                                product.is_sellable = NSNumber(value: ((itemDict["is_sellable"] as AnyObject).intValue)! as Int)
                                if(itemDict["images"] as? String != nil){
                                    product.images = itemDict["images"] as? String
                                    let imageArray : NSArray = (product.images?.components(separatedBy: ","))! as NSArray
                                    
                                    for imageitem in imageArray{
                                        let item : String = imageitem as! String
                                        let theFileName = (item as NSString).lastPathComponent
                                        print ("File details : \(theFileName) && \(item)")
                                        self.videoFiles?.add(item)

//                                        self.addImageUrlToDownloadQueue(item, imageId: theFileName)
                                    }
                                }
                                
                                product.created_on = self.getDateFromString(itemDict["created_on"] as! String)
                                if(itemDict["primary_image"] as? String != nil){
                                    product.primary_image = itemDict["primary_image"] as? String
                                    let primaryImage : String = (product.primary_image)!
//                                    let primaryImageFileName = (primaryImage as NSString).lastPathComponent
                                    self.videoFiles?.add(primaryImage)
//
//                                    self.addImageUrlToDownloadQueue(primaryImage, imageId: primaryImageFileName)
                                }
                                
                                if itemDict["video"] as? String != nil {
                                    product.video = itemDict["video"] as? String
                                    self.videoFiles?.add((product.video)!)
                                }
//                                DataManager.SaveProduct(product)
                            }
                            
                            
                        }
                    }
                    if (key=="sliders"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary

                            if (itemDict["product_id"] != nil ){
                                let myInt = Int((itemDict["product_id"] as! String))
                                if(myInt != 0){
                                    let slider:Slider = DataManager.initializeSliders()
                                    slider.id = itemDict["id"] as? String
                                    slider.collection_id = itemDict["collection_id"] as? String
                                    slider.product_id = itemDict["product_id"] as? String
                                    slider.sort_order = NSNumber(value: ((itemDict["sort_order"] as AnyObject).intValue)! as Int)
                                    slider.created_on = self.getDateFromString(itemDict["created_on"] as! String)
                                    // todo : title
                                    
//                                    DataManager.SaveSlider(slider)
                                }else{
                                    
                                }

                                
                            }
                            
                            
                        }
                    }
                    if (key=="color_manage"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let color:Color_manage = DataManager.initializeColor_manage()
                            color.id = itemDict["id"] as? String
                            color.color = itemDict["color"] as? String
                            color.code = itemDict["code"] as? String
//                            DataManager.SaveColor(color)
                            
                        }
                    }
                    if (key=="size_manage"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let size:Size_manage = DataManager.initializeSize_manage()
                            size.id = NSNumber(value: ((itemDict["id"] as AnyObject).intValue)! as Int)
                            size.size = itemDict["size"] as? String
//                            DataManager.SaveSize(size)
                            
                        }
                    }
                    if (key=="store"){
                        print("\(key) -> \(value)")

                        let array : NSArray = value as! NSArray
                        for item in array{
                            let itemDict : NSDictionary = item as! NSDictionary
                            let storeModelObj:Store = DataManager.initializeStore()
                            storeModelObj.id = itemDict["id"] as? String
                            storeModelObj.account_number = itemDict["account_number"] as? String
                            storeModelObj.name = itemDict["name"] as? String
                            storeModelObj.email = itemDict["email"] as? String
                            storeModelObj.contact = itemDict["contact_name"] as? String
                            storeModelObj.phone = itemDict["phone"] as? String
                            storeModelObj.zip = itemDict["zip"] as? String
                            storeModelObj.state = itemDict["state"] as? String
                            storeModelObj.city = itemDict["city"] as? String
                            storeModelObj.address1 = itemDict["address1"] as? String
                            storeModelObj.address2 = itemDict["address2"] as? String
                            
                            storeModelObj.shipping_address1 = itemDict["shipping_address1"] as? String
                            storeModelObj.shipping_address2 = itemDict["shipping_address2"] as? String
                            storeModelObj.shipping_city = itemDict["shipping_city"] as? String
                            storeModelObj.shipping_state = itemDict["shipping_state"] as? String
                            storeModelObj.shipping_zip = itemDict["shipping_zip"] as? String
                            storeModelObj.shipping_country = itemDict["shipping_country"] as? String
                            let myString: String? = itemDict["fax"] as? String
                            if (myString ?? "").isEmpty {
                                storeModelObj.fax = ""
                            }
                            else
                            {
                                storeModelObj.fax = myString
                            }
                            storeModelObj.is_active = NSNumber(value: ((itemDict["fax"] as AnyObject).intValue)! as Int)
                            
                            storeModelObj.created_on = self.getDateFromString(itemDict["created_on"] as! String)
                            
//                            DataManager.SaveStore(storeModelObj)
                            /*
                             id
                             account_number
                             name
                             address1
                             address2
                             city
                             state
                             zip
                             country
                             email
                             phone
                             fax
                             website
                             is_active
                             created_on
                             */
                            
                        }
                    }
                
                }
                print(dict)
                DataManager.Save()
               
//                self.videoIndex = self.videoIndex+1

                if(self.appDelegate!.getCurrentSalesmanId() == nil){
                    let salesman: Salesman = DataManager.GetCurrentSalesman(self.salesmanEmail!)! as Salesman
                    self.appDelegate?.setCurrentSalesmanId((salesman.id)!)
                }
               

                DispatchQueue.main.async {
                    /*shawn@abc.com*/
                    self.progressView.isHidden = false
                    self.progressView.progress = 0
                    if self.videoFiles?.count == 0 {
                        self.progressView.isHidden = true
                        self.progressView.progress = 0
                    }else{
                        self.videoIndex = 0
                        self.progressView.isHidden = false
                        
                        self.downloadVideoUrlAtIndex(self.videoIndex)
                        
                    }
                                    }
            }
            catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }
    
    func getDateFromString(_ stringDate:String)->Date{
        let strDate = stringDate // "2015-10-06T15:42:34Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print ( dateFormatter.date( from: strDate ) )
        return dateFormatter.date( from: strDate )!
    }
    
    func getDateFromString2(_ stringDate:String)->Date{
        let strDate = stringDate // "2015-10-06T15:42:34Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print ( dateFormatter.date( from: strDate ) )
        return dateFormatter.date( from: strDate )!
    }
}



