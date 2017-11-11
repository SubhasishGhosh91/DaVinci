//
//  SignatureViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/7/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController , YPDrawSignatureViewDelegate{

    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    var completionHandler:((UIImage)->Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.signatureView.delegate = self
        
        self.btnClear.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        
        self.btnClear.layer.borderWidth = 2.0
        
        self.btnSubmit.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        
        self.btnSubmit.layer.borderWidth = 2.0
        
        
        self.btnCancel.layer.borderColor=UIColor(red: 254/255.0, green: 206/255.0, blue: 222/255.0, alpha: 1.0).cgColor
        
        self.btnCancel.layer.borderWidth = 2.0

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
    @IBAction func clearAction(_ sender: AnyObject) {
        self.signatureView.clearSignature()

    }
    
    func clearSignature(_ sender: UIButton) {
        // This is how the signature gets cleared
        self.signatureView.clearSignature()
    }
    
    func saveSignature(_ sender: UIButton) {
        // Getting the Signature Image from self.drawSignatureView using the method getSignature().
        if let signatureImage = self.signatureView.getSignature(scale: 1) {
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            self.signatureView.clearSignature()
        }
    }
    
    // The delegate methods gives feedback to the instanciating class
    func finishedSignatureDrawing() {
        print("Finished")
    }
    
    func startedSignatureDrawing() {
        print("Started")
    }

    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func actionSubmit(_ sender: AnyObject) {
        if let signatureImage = self.signatureView.getSignature(scale: 0.5) {
            if let callback = self.completionHandler {
                callback (signatureImage)
            }
            self.signatureView.clearSignature()
        }

        self.dismiss(animated: true, completion: nil);
    }
}
