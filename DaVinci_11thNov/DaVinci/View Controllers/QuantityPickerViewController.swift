//
//  QuantityPickerViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/7/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class QuantityPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var quantityTable: UITableView!
    var selectedObjects : NSMutableArray!
    var completionHandler:((String)->Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.quantityTable.register(UINib(nibName: "SizeTableViewCell", bundle: nil), forCellReuseIdentifier: "SizeTableViewCell")
        
        // iOS 7
        if(self.quantityTable.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            self.quantityTable.separatorInset = UIEdgeInsets.zero
        }
        
        // iOS 8
        if(self.quantityTable.responds(to: #selector(setter: UIView.layoutMargins))){
            self.quantityTable.layoutMargins = UIEdgeInsets.zero;
        }
        
        if self.selectedObjects == nil {
            self.selectedObjects = NSMutableArray()
        }
        
        self.quantityTable.rowHeight = UITableViewAutomaticDimension;
        self.quantityTable.estimatedRowHeight = 44.0;

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 15
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :SizeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SizeTableViewCell", for: indexPath) as! SizeTableViewCell
        cell.labelSizeNumber.text = "\(indexPath.row+1)"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if(self.selectedObjects.contains("\(indexPath.row+1)")){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.selectedObjects.contains("\(indexPath.row+1)")){
            self.selectedObjects.remove("\(indexPath.row+1)")
        }else{
            self.selectedObjects.removeAllObjects()
            self.selectedObjects.add("\(indexPath.row+1)")
        }
        tableView.reloadData()
        
        if let callback = self.completionHandler {
            callback ("\(indexPath.row+1)")
        }
        
        self.dismiss(animated: true, completion: nil)

    }
}
