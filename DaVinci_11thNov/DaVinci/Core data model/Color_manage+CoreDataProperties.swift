//
//  Color_manage+CoreDataProperties.swift
//  DaVinci
//
//  Created by Avik Roy on 9/24/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Color_manage {

    @NSManaged var id: String?
    @NSManaged var color: String?
    @NSManaged var code: String?

}
