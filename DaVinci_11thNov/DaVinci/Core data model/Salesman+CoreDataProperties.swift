//
//  Salesman+CoreDataProperties.swift
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

extension Salesman {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var contact: String?
    @NSManaged var phone: String?
    @NSManaged var fax: String?
    @NSManaged var is_active: NSNumber?
    @NSManaged var created_on: Date?

}
