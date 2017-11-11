//
//  PichandZoomImageViewControlelrViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/5/16.
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


class PichandZoomImageViewControlelrViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var pinchCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    var product:Products?
    var imageArray : NSMutableArray?
    var isFullScreenLayout = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "PinchCollectionViewCell", bundle: nil)
        self.pinchCollectionView?.register(nib, forCellWithReuseIdentifier: "PinchCollectionViewCell")
//        let nibVideo = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
//        self.pinchCollectionView?.registerNib(nibVideo, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        self.pinchCollectionView.isPagingEnabled = true;
        
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PichandZoomImageViewControlelrViewController.handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1 // 1 second press
        self.pinchCollectionView.addGestureRecognizer(tapGesture)
        self.pinchCollectionView.delegate  = self;
        self.pinchCollectionView.dataSource = self;
//        self.pinchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

        if product?.images != nil {
            imageArray  = NSMutableArray(array: (product!.images?.components(separatedBy: ","))!)
            if( imageArray?.count>0){
                if product?.primary_image != nil{
                    self.navigationItem.title = "1 of \(((imageArray?.count)! + 1))"
                    
                }else{
                    self.navigationItem.title = "1 of \((imageArray?.count)!)"
                    
                }
                
            }
        }else{
            imageArray = NSMutableArray()
        }
        
        if product?.primary_image != nil {
            imageArray?.insert((product?.primary_image)!, at: 0)
        }
        
        let layout:UICollectionViewFlowLayout  = self.pinchCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.scrollDirection = .horizontal
        
        self.view.backgroundColor = UIColor.red
        self.pinchCollectionView.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
//        for imageitem in imageArray{
//            let item : String = imageitem as! String
//        }
        
        isFullScreenLayout = true;
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //                self.collectionViewTop.constant = 0
        self.view.backgroundColor = UIColor.black
        self.pinchCollectionView.reloadData()

    }
    
    func handleTap(_ tapGesture:UITapGestureRecognizer) {
        
        let p = tapGesture.location(in: self.pinchCollectionView)
        let indexPath = self.pinchCollectionView.indexPathForItem(at: p)
        
        if indexPath == nil {
        }
        else {
            print("tap on row, at \(indexPath!.row)")
            if(isFullScreenLayout == false){
                isFullScreenLayout = true;
                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                self.collectionViewTop.constant = 0
                self.view.backgroundColor = UIColor.black
                self.pinchCollectionView.reloadData()
                
            }else{
//                self.collectionViewTop.constant = 64
                isFullScreenLayout = false;
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.pinchCollectionView.reloadData()

            }
            
//            self.navigationController?.setNavigationBarHidden(true, animated: true)

        }
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                          sizeForItemAt indexPath: IndexPath) -> CGSize{
        if(isFullScreenLayout == false){
            return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }else{
            return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64)

        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((imageArray?.count)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCollectionViewCell", forIndexPath: indexPath) as! VideoCollectionViewCell
//            let item : String = (product?.video)!
//            let videoFieldName = (item as NSString).lastPathComponent
//            let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("\(videoFieldName)")
//            let requestURL = NSURL(string:filename)
//            let request = NSURLRequest(URL:requestURL!);
//            cell.webView.loadRequest(request)
//            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PinchCollectionViewCell", forIndexPath: indexPath) as! PinchCollectionViewCell
//            let item : String = imageArray![indexPath.row-1] as! String
//            let imageFieldName = (item as NSString).lastPathComponent
//            let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("\(imageFieldName)")
//            
//            loadImageFromUrl(filename, view: cell.cellImage)
//            cell.pinchScrollView.zoomScale = 1.0;
//            return cell
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinchCollectionViewCell", for: indexPath) as! PinchCollectionViewCell
        let item : String = imageArray![indexPath.row] as! String
        let imageFieldName = (item as NSString).lastPathComponent
        let filename = self.getDocumentsDirectory().appendingPathComponent("\(imageFieldName)")
        cell.cellImage.contentMode = UIViewContentMode.scaleAspectFit

        loadImageFromUrl(filename, view: cell.cellImage)
        cell.pinchScrollView.zoomScale = 1.0;
//        cell.pinchScrollView.backgroundColor = UIColor.redColor()
//        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let curretntPage:NSInteger = (NSInteger) (self.pinchCollectionView.contentOffset.x/self.pinchCollectionView.frame.size.width)
        self.navigationItem.title = "\(curretntPage+1) of \((imageArray?.count)!)"

        
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

    
    func loadImageFromUrl(_ urlFile: String, view: UIImageView){
//        let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("\(urlFile)")
        // Create Url from string
        let url = URL(fileURLWithPath: urlFile)
        
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
    
}
