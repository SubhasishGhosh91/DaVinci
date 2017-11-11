//
//  Products+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 7/22/17.
//  Copyright © 2017 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Products {

    @NSManaged var collection_id: String?
    @NSManaged var color: String?
    @NSManaged var created_on: Date?
    @NSManaged var fabric: String?
    @NSManaged var id: NSNumber?
    @NSManaged var images: String?
    @NSManaged var is_sellable: NSNumber?
    @NSManaged var price: NSNumber?
    @NSManaged var primary_image: String?
    @NSManaged var size: String?
    @NSManaged var style: String?
    @NSManaged var video: String?

}
