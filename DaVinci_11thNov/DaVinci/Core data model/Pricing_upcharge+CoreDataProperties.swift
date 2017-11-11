//
//  Pricing_upcharge+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 5/14/17.
//  Copyright © 2017 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pricing_upcharge {

    @NSManaged var category_id: String?
    @NSManaged var id: String?
    @NSManaged var price: NSNumber?
    @NSManaged var product_size: String?

}
