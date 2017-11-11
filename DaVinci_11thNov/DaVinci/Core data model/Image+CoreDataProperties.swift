//
//  Image+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 11/16/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var sourceurl: String?
    @NSManaged var fileurl: String?

}
