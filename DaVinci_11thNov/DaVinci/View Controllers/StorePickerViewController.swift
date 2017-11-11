//
//  StorePickerViewController.swift
//  DaVinci
//
//  Created by Aviru bhattacharjee on 24/09/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class StorePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var completionHandler:((Store)->Void)!
    
    @IBOutlet weak var storeTableView: UITableView!
    
    var arrayForComboBox:NSArray?
    
    var selectedObjects : NSMutableArray!
    
    var appDelegate:AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        arrayForComboBox = DataManager.GetAllStores()
        
        self.storeTableView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "storeCell")
        
        // iOS 7
        if(self.storeTableView.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            self.storeTableView.separatorInset = UIEdgeInsets.zero
        }
        
        // iOS 8
        if(self.storeTableView.responds(to: #selector(setter: UIView.layoutMargins))){
            self.storeTableView.layoutMargins = UIEdgeInsets.zero;
        }
        
        self.selectedObjects = NSMutableArray()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayForComboBox!.count
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :StoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! StoreTableViewCell
        let storeObj:Store = arrayForComboBox![indexPath.row] as! Store
        cell.lblStoreName.text = storeObj.name!
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.selectedObjects.contains(arrayForComboBox![indexPath.row])){
            self.selectedObjects.remove(arrayForComboBox![indexPath.row])
        }else{
            self.selectedObjects.removeAllObjects()
            self.selectedObjects.add(arrayForComboBox![indexPath.row])
        }
        self.storeTableView.reloadData()
        
        if let callback = self.completionHandler {
            callback (arrayForComboBox![indexPath.row] as! Store)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
