//
//  CollectionPickerViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/9/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class CollectionPickerViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var completionHandler:((Collections)->Void)!
    @IBOutlet weak var accountCollection: UITableView!
    var arrayForComboBox:NSArray = []
    
    var selectedObjects : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayForComboBox = DataManager.GetAllCollections() as! [Collections] as NSArray

        self.accountCollection.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        
        // iOS 7
        if(self.accountCollection.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            self.accountCollection.separatorInset = UIEdgeInsets.zero
        }
        
        // iOS 8
        if(self.accountCollection.responds(to: #selector(setter: UIView.layoutMargins))){
            self.accountCollection.layoutMargins = UIEdgeInsets.zero;
        }
        
        self.selectedObjects = NSMutableArray()
        
        self.accountCollection.rowHeight = UITableViewAutomaticDimension;
        self.accountCollection.estimatedRowHeight = 44.0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayForComboBox = DataManager.GetAllCollections() as! [Collections] as NSArray
        accountCollection.reloadData()
        self.selectedObjects = NSMutableArray()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayForComboBox.count
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :CollectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        let collection:Collections = arrayForComboBox[indexPath.row] as! Collections
        cell.collectionName.text = collection.name!
//        if(self.selectedObjects.containsObject(arrayForComboBox[indexPath.row])){
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryType.None
//        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(self.selectedObjects.containsObject(arrayForComboBox[indexPath.row])){
//            self.selectedObjects.removeObject(arrayForComboBox[indexPath.row])
//        }else{
//            self.selectedObjects.removeAllObjects()
//            self.selectedObjects.addObject(arrayForComboBox[indexPath.row])
//        }
//        self.accountCollection.reloadData()
        
        if let callback = self.completionHandler {
            callback (arrayForComboBox[indexPath.row] as! Collections)
        }
        
        self.dismiss(animated: true, completion: nil)

    }

}
