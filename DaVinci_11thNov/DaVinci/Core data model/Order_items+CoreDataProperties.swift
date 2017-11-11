//
//  Order_items+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 9/25/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Order_items {

    @NSManaged var color: String?
    @NSManaged var id: String?
    @NSManaged var note: String?
    @NSManaged var order_id: String?
    @NSManaged var price: NSNumber?
    @NSManaged var product_id: String?
    @NSManaged var quantity: String?
    @NSManaged var size: String?
    @NSManaged var style: String?
    @NSManaged var unit_price: NSNumber?

}
