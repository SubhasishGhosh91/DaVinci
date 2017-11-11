//
//  Collections+CoreDataProperties.swift
//  
//
//  Created by Avik Roy on 9/11/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Collections {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var created_on: Date?

}
