//
//  ColorPickerViewControlelrViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/5/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class ColorPickerViewControlelrViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {
    
    @IBOutlet weak var tableColorPicker: UITableView?
    var selectedObjects : NSMutableArray!
    var completionHandler:((Color_manage)->Void)!
    let arrayForComboBox = ["Red", "Blue", "Green", "Cyan", "Magenta"]
    var colorArray:NSArray?
    var product:Products?
    override func viewDidLoad() {
        super.viewDidLoad()
        colorArray = DataManager.GetColorsForSelectedProducts(product!)
        self.tableColorPicker!.register(UINib(nibName: "ColorTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorTableViewCell")
        //        self.tableColorPicker.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Do any additional setup after loading the view.
        // iOS 7
        if(self.tableColorPicker!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            self.tableColorPicker!.separatorInset = UIEdgeInsets.zero
        }
        
        // iOS 8
        if(self.tableColorPicker!.responds(to: #selector(setter: UIView.layoutMargins))){
            self.tableColorPicker!.layoutMargins = UIEdgeInsets.zero;
        }
        
        self.selectedObjects = NSMutableArray()
        
        self.tableColorPicker!.rowHeight = UITableViewAutomaticDimension;
        self.tableColorPicker!.estimatedRowHeight = 44.0;
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetColorValue(){
        
        if ((tableColorPicker) != nil) {
            self.colorArray = DataManager.GetColorsForSelectedProducts(self.product!)
            self.selectedObjects = NSMutableArray()
            self.tableColorPicker!.reloadData()
            
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
        return (self.colorArray?.count)!
    }
    
    //it seem that you have to add a è
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :ColorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ColorTableViewCell", for: indexPath) as! ColorTableViewCell
        
        let color:Color_manage = colorArray![indexPath.row] as! Color_manage
        
        
        cell.colorView.backgroundColor = UIColor().HexToColor("#\((color.code)!)", alpha: 1.0) /*UIColor.magentaColor()*/
        cell.colorName.text = color.color
        cell.colorName.sizeToFit()
        
        if(self.selectedObjects.count > indexPath.row){
            if(self.selectedObjects.contains(arrayForComboBox[indexPath.row])){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.selectedObjects.contains(colorArray![indexPath.row])){
            self.selectedObjects.remove(colorArray![indexPath.row])
        }else{
            self.selectedObjects.removeAllObjects()
            self.selectedObjects.add(colorArray![indexPath.row])
        }
        tableView.reloadData()
        
        if let callback = self.completionHandler {
            callback (colorArray![indexPath.row] as! Color_manage)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}

extension UIColor{
    func HexToColor(_ hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
