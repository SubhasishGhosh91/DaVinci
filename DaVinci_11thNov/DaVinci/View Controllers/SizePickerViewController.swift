//
//  SizePickerViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/7/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class SizePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedObjects : NSMutableArray!
    var completionHandler:((Size_manage)->Void)!
    var sizeArray:NSArray?
    var product:Products?
    @IBOutlet weak var tableViewSize: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeArray = DataManager.GetSizesForSelectedProducts(product!)

        self.tableViewSize!.register(UINib(nibName: "SizeTableViewCell", bundle: nil), forCellReuseIdentifier: "SizeTableViewCell")
        // iOS 7
        if(self.tableViewSize!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            self.tableViewSize!.separatorInset = UIEdgeInsets.zero
        }
        
        // iOS 8
        if(self.tableViewSize!.responds(to: #selector(setter: UIView.layoutMargins))){
            self.tableViewSize!.layoutMargins = UIEdgeInsets.zero;
        }
        
        self.selectedObjects = NSMutableArray()
        
        self.tableViewSize!.rowHeight = UITableViewAutomaticDimension;
        self.tableViewSize!.estimatedRowHeight = 44.0;


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetSizeValue(){
        
        if ((tableViewSize) != nil) {
            self.sizeArray = DataManager.GetSizesForSelectedProducts(self.product!)
            self.selectedObjects = NSMutableArray()
            self.tableViewSize!.reloadData()
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (sizeArray?.count)!
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :SizeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SizeTableViewCell", for: indexPath) as! SizeTableViewCell
        let size:Size_manage = sizeArray![indexPath.row] as! Size_manage

        cell.labelSizeNumber.text = "\((size.size)!)"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if(self.selectedObjects.contains("\(indexPath.row+1)")){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.selectedObjects.contains(sizeArray![indexPath.row])){
            self.selectedObjects.remove(sizeArray![indexPath.row])
        }else{
            self.selectedObjects.removeAllObjects()
            self.selectedObjects.add(sizeArray![indexPath.row])
        }
        tableView.reloadData()
        
        if let callback = self.completionHandler {
            callback (sizeArray![indexPath.row] as! Size_manage)

        }
        
        self.dismiss(animated: true, completion: nil)

    }
}
