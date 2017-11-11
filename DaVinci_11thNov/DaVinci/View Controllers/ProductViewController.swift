//
//  ProductViewController.swift
//  DaVinci
//
//  Created by Avik Roy on 6/20/16.
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


class ProductViewController: BaseViewController , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UISearchBarDelegate{
    @IBOutlet var buttonCart: UIButton!
    var products:NSArray?
    var filteredProducts:NSArray?
    
    var appDelegate:AppDelegate?
    @IBOutlet weak var seacrhBarProduct: UISearchBar!
    
    @IBOutlet weak var collectionViewProduct: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="PRODUCTS"
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionViewProduct?.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        self.seacrhBarProduct.isTranslucent = false
        self.seacrhBarProduct.backgroundImage = UIImage()
        self.seacrhBarProduct.delegate = self
        self.seacrhBarProduct.keyboardType = UIKeyboardType.numberPad
        
        let barButton = UIBarButtonItem(customView: self.buttonCart)
        self.navigationItem.rightBarButtonItem = barButton
        
        let flow = collectionViewProduct.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        if((appDelegate!.selectedCollection?.id) != nil){
            products = DataManager.GetAllProductsForCollectionId(appDelegate!.selectedCollection!.id!)
            if products?.count > 0{
                filteredProducts = NSArray(array: products!)
                
            }else{
                filteredProducts = NSArray()
            }
        }else{
            filteredProducts = NSArray()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.appDelegate!.getCurrentOrderId() != nil){
            let totalCount = DataManager.getTotalItemCountForOrderId(self.appDelegate!.getCurrentOrderId()!)
            
            //            let orderItems:NSArray = DataManager.GetAllOrderItemsForOrderId(self.appDelegate!.getCurrentOrderId()! )
            self.buttonCart.setTitle("\(totalCount)", for: UIControlState());
            self.buttonCart.setTitle("\(totalCount)", for: UIControlState.highlighted);
            
        }else{
            self.buttonCart.setTitle("0", for: UIControlState());
            self.buttonCart.setTitle("0", for: UIControlState.highlighted);
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (filteredProducts?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let product:Products = (filteredProducts?.object(at: indexPath.row))! as! Products
        cell.labelProductNamePrice.text = "Style \(product.style!) - $\(product.price!)"
        //        cell.productImage.image = UIImage(named: "dummy");
        cell.productImage.contentMode = UIViewContentMode.scaleAspectFit
        if DataManager.GetImageFromImageUrl((product.primary_image)!) != nil{
            let image:String = DataManager.GetImageFromImageUrl((product.primary_image)!)!
            loadImageFromUrl(image, view: cell.productImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width/3-20, height: 350)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller:ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        controller.selectedProduct = (filteredProducts?.object(at: indexPath.row))! as? Products
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override var shouldAutorotate : Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
            return false
        }
        else {
            return true
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    
    func updateSearchResultsForSearchController() {
        let searchString = self.seacrhBarProduct.text
        
        let resultPredicate = NSPredicate(format: "SELF.style contains[cd] %@", searchString!)
        self.filteredProducts = self.products!.filtered(using: resultPredicate) as NSArray
        
        self.collectionViewProduct.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if products?.count > 0{
            filteredProducts = NSArray(array: products!)
        }
        self.collectionViewProduct.reloadData()
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.updateSearchResultsForSearchController()
        }else{
            if products?.count > 0{
                filteredProducts = NSArray(array: products!)
            }
            self.collectionViewProduct.reloadData()
        }
    }
    
    @IBAction func cartAction(_ sender: AnyObject) {
        let controller:OrderViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true);
    }
    
}
