//
//  Vendor+CoreDataProperties.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/21.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vendor {

    @NSManaged var vendor_name: String?
    @NSManaged var department: Department?
    @NSManaged var payments: NSSet?

}
