//
//  BaseViewController.swift
//  DaVinci
//
//  Created by Aviru bhattacharjee on 24/09/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
     func startActivity(_ view: UIView) -> UIActivityIndicatorView {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        activityView.color = UIColor.gray
        view.addSubview(activityView)
        view.isUserInteractionEnabled = false
        activityView.startAnimating()
        return activityView
    }
    
     func stopActivity(_ view: UIView) -> UIActivityIndicatorView {
        let activityView: UIActivityIndicatorView = self.activityForView(view)
        activityView.center = view.center
        activityView.hidesWhenStopped = true
        //view.addSubview(activityView)
        view.isUserInteractionEnabled = true
        activityView.stopAnimating()
        return activityView
    }
    
     func activityForView(_ view: UIView) -> UIActivityIndicatorView {
        var activity: UIActivityIndicatorView? = nil
        let subviews = view.subviews
        let activityClass = UIActivityIndicatorView.self
        for view: UIView in subviews {
            if (view .isKind(of: activityClass) ) {
                activity = (view as! UIActivityIndicatorView)
            }
        }
        return activity!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
    func loadImageFromUrl(_ urlFile: String, view: UIImageView){
        let filename = self.getDocumentsDirectory().appendingPathComponent("\(urlFile)")
        // Create Url from string
        let url = URL(fileURLWithPath: filename)
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }) 
        
        // Run task
        task.resume()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
