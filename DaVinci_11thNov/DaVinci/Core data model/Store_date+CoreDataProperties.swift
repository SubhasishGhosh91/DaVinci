//
//  Store_date+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 4/21/17.
//  Copyright © 2017 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Store_date {

    @NSManaged var start_date: Date?
    @NSManaged var end_date: Date?
    @NSManaged var completion_date: Date?

}
