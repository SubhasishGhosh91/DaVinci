//
//  PopOverProductViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 7/1/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class PopOverProductViewController: BaseViewController , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    var appDelegate:AppDelegate?
    
    var products:NSMutableArray?
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var collectionViewProduct: UICollectionView!
    var completionHandler:((Products)->Void)!
    var order:Orders?
    var orderItems:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionViewProduct?.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        let flow = collectionViewProduct.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.collectionViewProduct.showsVerticalScrollIndicator = false;
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = NSMutableArray()
        
        
        if(appDelegate?.selectedCollection != nil && self.appDelegate!.getCurrentOrderId() != nil){
            order = DataManager.GetCurrentOrderForOrderId(self.appDelegate!.getCurrentOrderId()!)
            orderItems = DataManager.GetAllOrderItemsForOrderId((order?.id)!)
            
            if(orderItems!.count > 0){
                for index in 0...orderItems!.count-1{
                    let orderItem:Order_items = orderItems![index] as! Order_items
                    let product:Products = DataManager.GetProductForProductId((orderItem.product_id)!)!
                    
                    products?.add(product)
                }
            }else{
                products = NSMutableArray()
            }
            
            
            
        }else{
            products = NSMutableArray()
        }
        collectionViewProduct.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (products?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let product:Products = (products?.object(at: indexPath.row))! as! Products
        cell.labelProductNamePrice.text = "Style \(product.style!) - $\(product.price!)"
        cell.productImage.contentMode = UIViewContentMode.scaleAspectFit
        let image:String = DataManager.GetImageFromImageUrl((product.primary_image)!)!
        loadImageFromUrl(image, view: cell.productImage)
        //        cell.productImage.image = UIImage(named: "dummy");
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize: CGRect = self.view.bounds
        return CGSize(width: screenSize.width/3-20, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let callback = self.completionHandler {
            
            let product:Products = (products?.object(at: indexPath.row))! as! Products
            callback (product)
        }else{
            let controller:ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    
    
}
