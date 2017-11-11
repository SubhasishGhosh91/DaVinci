//
//  NoteViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/2/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var textNote: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    var order_item:Order_items?
    var order:Orders?
    @IBOutlet weak var noteLabe: UILabel!
    var orderItemNote = false
    var completionHandler:(()->Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.textNote.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.textNote.layer.borderWidth = 2.0
        
        self.btnSubmit.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor

        self.btnSubmit.layer.borderWidth = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetNote(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textNote.text = ""
        if((order_item) != nil && orderItemNote){
            self.textNote.text = self.order_item?.note
            
        }
        
        if((order) != nil && !orderItemNote){
            self.textNote.text = self.order?.order_note
            
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

    @IBAction func actionSubmit(_ sender: AnyObject) {
        if((order_item) != nil && orderItemNote){
            self.order_item?.note = self.textNote.text
            DataManager.UpdateOrderItem(order_item!)

        }
        if((order) != nil && !orderItemNote){
            self.order?.order_note = self.textNote.text
            DataManager.UpdateOrder(order!)
            
        }
        
        if let callback = self.completionHandler {
            callback ()
        }

        self.dismiss(animated: true, completion: nil)
    }
}
