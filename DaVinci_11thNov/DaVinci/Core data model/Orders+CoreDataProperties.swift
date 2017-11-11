//
//  Orders+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 10/15/17.
//  Copyright © 2017 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Orders {

    @NSManaged var bill_to: String?
    @NSManaged var catelouge: String?
    @NSManaged var complition_date: Date?
    @NSManaged var contact: String?
    @NSManaged var created_on: Date?
    @NSManaged var email: String?
    @NSManaged var fax: String?
    @NSManaged var id: String?
    @NSManaged var image: Data?
    @NSManaged var order_date: Date?
    @NSManaged var order_editable: NSNumber?
    @NSManaged var order_id: String?
    @NSManaged var order_note: String?
    @NSManaged var order_submitted: NSNumber?
    @NSManaged var phone: String?
    @NSManaged var po: String?
    @NSManaged var salesman_id: String?
    @NSManaged var ship_to: String?
    @NSManaged var signature: String?
    @NSManaged var start_date: Date?
    @NSManaged var store_id: String?
    @NSManaged var short_order_id: String?

}
