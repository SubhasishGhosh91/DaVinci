//
//  Store+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 3/5/17.
//  Copyright © 2017 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Store {

    @NSManaged var account_number: String?
    @NSManaged var address1: String?
    @NSManaged var address2: String?
    @NSManaged var city: String?
    @NSManaged var contact: String?
    @NSManaged var created_on: Date?
    @NSManaged var email: String?
    @NSManaged var fax: String?
    @NSManaged var id: String?
    @NSManaged var is_active: NSNumber?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var state: String?
    @NSManaged var zip: String?
    @NSManaged var shipping_address1: String?
    @NSManaged var shipping_address2: String?
    @NSManaged var shipping_city: String?
    @NSManaged var shipping_state: String?
    @NSManaged var shipping_zip: String?
    @NSManaged var shipping_country: String?
    @NSManaged var address3: String?
    @NSManaged var shipping_address3: String?

}
