//
//  Slider+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 9/11/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Slider {

    @NSManaged var id: String?
    @NSManaged var collection_id: String?
    @NSManaged var title: String?
    @NSManaged var image: String?
    @NSManaged var sort_order: NSNumber?
    @NSManaged var created_on: Date?
    @NSManaged var product_id: String?

}
