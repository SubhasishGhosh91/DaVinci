//
//  DataManager.swift
//  DaVinci
//
//  Created by Avik Roy on 9/11/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    class func SaveCollection(_ collections:Collections)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveStoreDate(_ store_date:Store_date)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveColor(_ color:Color_manage)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func Save()  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveSize(_ size:Size_manage)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveProduct(_ product:Products)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveStore(_ store:Store)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveOrders(_ order:Orders)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveOrderItems(_ orderItems:Order_items)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveImageUrl(_ image:Image)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }


    class func SavePricingUpcharge(_ pricingUpcharge:Pricing_upcharge)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func SaveSlider(_ slider:Slider)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    class func SaveSalesman(_ salesman:Salesman)  {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    class func GetAllCollections()->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Collections",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
//        let pred = NSPredicate(format: "(name = %@)", name.text)
//        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
//        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }

        return returnObject as NSArray
        
    }
    
    class func GetCollectionForCollectionId(_ prod_id:String)->Collections?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Collections",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", prod_id)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        //        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        
        if returnObject.count>0{
            return returnObject[0] as? Collections
            
        }else{
            return nil
        }

        
    }
    
//    class func GetPriceUpchargeFor(size:String)->Pricing_upcharge?{
//        
//        var returnObject : Array<AnyObject> = []
//        
//        let appDelegate =
//            UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        let entityDescription =
//            NSEntityDescription.entityForName("Pricing_upcharge",
//                                              inManagedObjectContext: managedContext)
//        
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        
//        let pred = NSPredicate(format: "(size = %@)", size)
//        request.predicate = pred
//        
//        if returnObject.count>0{
//            return (returnObject[0] as? Pricing_upcharge)!
//            
//        }else{
//            return nil;
//        }
//
//        
//    }

    
    class func GetAllProductsForCollectionId(_ collectionId:String)->NSArray?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Products",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(collection_id = %@) and (is_sellable = 1)", collectionId)
        request.predicate = pred
        let sort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnObject as NSArray
        
    }
    
    class func GetColorsForSelectedProducts(_ product:Products)->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Color_manage",
                                              in: managedContext)
        
        let colorArray:NSArray = (product.color?.components(separatedBy: ","))! as NSArray
        var predicateString:String = ""
        
        for item in 0...colorArray.count-1{
            let stringItem = colorArray[item] as! String
            if stringItem.characters.count > 0 {
                if(colorArray.count > 1){
                    predicateString = predicateString + "(id = \(stringItem))"
                    if item != (colorArray.count-1) {
                        predicateString = predicateString + "||";
                    }

                }else{
                    predicateString = predicateString + "(id = \(stringItem))"

                }
            }
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
    
        if(predicateString.characters.count > 0){
            let pred = NSPredicate(format: "\(predicateString)")
            request.predicate = pred
            do {
                returnObject =
                    try managedContext.fetch(request)
                
                
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            
            return returnObject as NSArray
        }
        
        return NSArray()
        
        
    }

    class func GetSizesForSelectedProducts(_ product:Products)->NSArray{
    
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Size_manage",
                                              in: managedContext)
        
        let colorArray:NSArray = (product.size?.components(separatedBy: ","))! as NSArray
        var predicateString:String = ""
        for item in 0...colorArray.count-1{
            let stringItem = colorArray[item] as! String
            if stringItem.characters.count > 0 {
                if(colorArray.count > 1){
                    predicateString = predicateString + "(id = \(stringItem))"
                    if item != (colorArray.count-1) {
                        predicateString = predicateString + "||";
                    }
                    
                }else{
                    predicateString = predicateString + "(id = \(stringItem))"
                    
                }
            }
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        
        if(predicateString.characters.count > 0){
            let pred = NSPredicate(format: "\(predicateString)")
            request.predicate = pred
            let sort = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sort]
            do {
                returnObject =
                    try managedContext.fetch(request)
                
                
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            return returnObject as NSArray
        }
        return NSArray()
        
    }

    class func GetAllSlidersForCollectionId(_ collectionId:String)->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Slider",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(collection_id = %@)", collectionId)
        request.predicate = pred
        
        let yearSort = NSSortDescriptor(key: "sort_order", ascending: true)
        request.sortDescriptors = [yearSort]
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
//        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }

        return returnObject as NSArray
        
    }

    class func GetProductForSliderId(_ productId:String)->Products?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Products",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", productId)
        request.predicate = pred
        
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
//        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        if returnObject.count>0{
            return returnObject[0] as? Products
            
        }else{
            return nil;
        }
        
    }
    
    class func GetProductForProductId(_ productId:String)->Products?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Products",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", productId)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
//        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        if returnObject.count>0{
            return returnObject[0] as? Products
            
        }else{
            return nil;
        }
        
    }

    class func GetCurrentOrderForOrderId(_ orderId:String)->Orders{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Orders",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", orderId)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnObject[0] as! Orders
        
    }
    
    class func GetStoreDate()->Store_date{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Store_date",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnObject[0] as! Store_date
        
    }
    
    
    class func GetAllCompletedOrders()->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Orders",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(order_submitted = %@)", NSNumber(value: true as Bool))
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        
        if(returnObject.count > 0){
            let sortDesc: NSSortDescriptor = NSSortDescriptor(key: "created_on", ascending: false);
            returnObject = (returnObject as NSArray).sortedArray(using: [sortDesc]) as Array<AnyObject> 

            
        }
        return returnObject as NSArray
        
    }
    
    class func GetPriceUpchargeFor(_ size:String, categoryId: String)->Pricing_upcharge?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Pricing_upcharge",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(product_size = %@) AND (category_id = %@)", size,categoryId)
        request.predicate = pred
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if returnObject.count>0{
            return (returnObject[0] as? Pricing_upcharge)!
            
        }else{
            return nil;
        }
        
        
    }

    
    class func GetAllEditableOrders()->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Orders",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(order_editable = %@)", NSNumber(value: true as Bool))
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        
        
        return returnObject as NSArray
        
    }
    
    class func GetAllOrderItemsForOrderId(_ orderId:String)->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Order_items",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(order_id = %@)", orderId)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
//        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }

        
        return returnObject as NSArray
        
    }
    
    class func UpdateOrderItem(_ orderItems:Order_items){
        
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Order_items",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", orderItems.id!)
        request.predicate = pred
        
        do {
            let returnObject =
                try managedContext.fetch(request)
            
            if returnObject.count != 0{
                
                let coreDataOrderItem:Order_items = returnObject[0] as! Order_items
                coreDataOrderItem.id = orderItems.id
                coreDataOrderItem.order_id = orderItems.order_id
                coreDataOrderItem.product_id = orderItems.product_id
                coreDataOrderItem.color = orderItems.color
                coreDataOrderItem.size = orderItems.size
                coreDataOrderItem.quantity = orderItems.quantity
                coreDataOrderItem.price = orderItems.price
                coreDataOrderItem.style = orderItems.style
                coreDataOrderItem.note = orderItems.note
                
                do {
                    try managedContext.save()
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }
    
    class func UpdateOrder(_ order:Orders){
        
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Orders",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", order.id!)
        request.predicate = pred
        
        do {
            let returnObject =
                try managedContext.fetch(request)
            
            if returnObject.count != 0{
                
                let coreDataOrder:Orders = returnObject[0] as! Orders
                coreDataOrder.id = order.id
                coreDataOrder.order_id = order.order_id
                coreDataOrder.bill_to = order.bill_to
                coreDataOrder.catelouge = order.catelouge
                coreDataOrder.complition_date = order.complition_date
                coreDataOrder.created_on = order.created_on
                coreDataOrder.order_date = order.order_date
                coreDataOrder.po = order.po
                coreDataOrder.salesman_id = order.salesman_id
                coreDataOrder.ship_to = order.ship_to
                coreDataOrder.signature = order.signature
                coreDataOrder.start_date = order.start_date
                coreDataOrder.order_submitted = order.order_submitted
                coreDataOrder.order_editable = order.order_editable

                do {
                    try managedContext.save()
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }


    class func CopyOrderItem(_ orderItems:Order_items){
        DataManager.SaveOrderItems(orderItems)
    }

    class func GetCurrentSalesman(_ email:String)->Salesman?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Salesman",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(email = %@)", email.lowercased())
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        if filteredElements.count>0{
            return filteredElements[0] as? Salesman

        }else{
            return nil;
        }
        
    }
    
    class func GetCurrentSalesmanFromId(_ id:String)->Salesman?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Salesman",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", id)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        if filteredElements.count>0{
            return filteredElements[0] as? Salesman
            
        }else{
            return nil;
        }
        
    }

    
    class func GetAllStoresForAccount(_ acId:String)->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Store",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(account_number = %@)", acId)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
//        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        
        return returnObject as NSArray
        
    }
    
    class func GetStoreForStoreAcNumber(_ storeAccountNumber:String)->Store?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Store",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(account_number = %@)", storeAccountNumber)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if returnObject.count > 0 {
            return returnObject[0] as? Store

        }else{
            return nil
        }
        
    }
    
    class func GetStoreForStoreId(_ storeId:String)->Store?{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Store",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(id = %@)", storeId)
        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if returnObject.count > 0 {
            return returnObject[0] as? Store
            
        }else{
            return nil
        }
        
    }
    
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
    class func GetImageFromImageUrl(_ imageUrl:String)->String?{
        let theFileName = (imageUrl as NSString).lastPathComponent
        return theFileName
//        var returnObject : Array<AnyObject> = []
//        
//        let appDelegate =
//            UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        let entityDescription =
//            NSEntityDescription.entityForName("Image",
//                                              inManagedObjectContext: managedContext)
//        
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        
//        let pred = NSPredicate(format: "(sourceurl = %@)", imageUrl)
//        request.predicate = pred
//        
//        do {
//            returnObject =
//                try managedContext.executeFetchRequest(request)
//            
//            
//            
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        //        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
//        if returnObject.count > 0 {
//            return returnObject[0] as? Image
//            
//        }else{
//            return nil
//        }
        
    }


    
    class func GetAllStores()->NSArray{
        
        var returnObject : Array<AnyObject> = []
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Store",
                                              in: managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
//        let pred = NSPredicate(format: "(account_number = %@)", acId)
//        request.predicate = pred
        
        do {
            returnObject =
                try managedContext.fetch(request)
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        //        let filteredElements = returnObject.filterDuplicates { $0.id == $1.id  }
        
        return returnObject as NSArray
        
    }


    
    class func removeDuplicates(_ array:NSArray) {
        
    }
    
    class func initializeCollections()->Collections{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Collections = Collections.init(entity: NSEntityDescription.entity(forEntityName: "Collections", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    
    class func initializePricingUpcharge()->Pricing_upcharge{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Pricing_upcharge = Pricing_upcharge.init(entity: NSEntityDescription.entity(forEntityName: "Pricing_upcharge", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    
    class func initializeSalesMan()->Salesman{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Salesman = Salesman.init(entity: NSEntityDescription.entity(forEntityName: "Salesman", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeProducts()->Products{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Products = Products.init(entity: NSEntityDescription.entity(forEntityName: "Products", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeSliders()->Slider{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Slider = Slider.init(entity: NSEntityDescription.entity(forEntityName: "Slider", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeColor_manage()->Color_manage{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Color_manage = Color_manage.init(entity: NSEntityDescription.entity(forEntityName: "Color_manage", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeSize_manage()->Size_manage{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Size_manage = Size_manage.init(entity: NSEntityDescription.entity(forEntityName: "Size_manage", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeSize_orders()->Orders{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Orders = Orders.init(entity: NSEntityDescription.entity(forEntityName: "Orders", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeSize_order_items()->Order_items{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Order_items = Order_items.init(entity: NSEntityDescription.entity(forEntityName: "Order_items", in:managedContext)!, insertInto: managedContext)
        return currentObject
    } 
    class func initializeStore()->Store{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Store = Store.init(entity: NSEntityDescription.entity(forEntityName: "Store", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeImage()->Image{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Image = Image.init(entity: NSEntityDescription.entity(forEntityName: "Image", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    class func initializeStoreDate()->Store_date{
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let currentObject:Store_date = Store_date.init(entity: NSEntityDescription.entity(forEntityName: "Store_date", in:managedContext)!, insertInto: managedContext)
        return currentObject
    }
    
    class func clearAll(){
        DataManager.clearCoreData("Collections")
        DataManager.clearCoreData("Salesman")
        DataManager.clearCoreData("Products")
        DataManager.clearCoreData("Color_manage")
        DataManager.clearCoreData("Size_manage")
        DataManager.clearCoreData("Slider")
        DataManager.clearCoreData("Store_date")
        DataManager.clearCoreData("Pricing_upcharge")
        DataManager.clearCoreData("Store")

//        DataManager.clearCoreData("Orders");
//        DataManager.clearCoreData("store_date");
        UserDefaults.standard.removeObject(forKey: "kOrderId")
        UserDefaults.standard.synchronize()

    }
    
    class func clearCoreData(_ entity:String) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    managedContext.delete(result)
                }
                
                try managedContext.save()
            }
        } catch {
            print("failed to clear core data")
        }
    }
    
    class func deleteOrderItems(_ orderItems:Order_items){
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        do {
            managedContext.delete(orderItems)

            try managedContext.save()

        } catch {
            print("failed to clear core data")
        }
        
        // save your changes 
    }
    
    class func getTotalItemCountForOrderId(_ order_id:String)->Int{
        let orderItems:NSArray = DataManager.GetAllOrderItemsForOrderId(order_id )
        var total = 0
        for item in orderItems{
            let order_item : Order_items = item as! Order_items
            if let number = Int("\((order_item.quantity)!)") {
                total = total+number
                
            }
            
        }
        return total

    }
}

extension Array {
    
    func filterDuplicates( _ includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}
