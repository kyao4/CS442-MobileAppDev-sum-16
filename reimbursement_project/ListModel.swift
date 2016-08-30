//
//  ListModel.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/29.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ListModel {
    
    
    static var managedObjectContext: NSManagedObjectContext!  {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    
    // MARK: - Fetched results controller
    
    static func paymentfetchedRequest() -> [Payment] {
        let moc = ListModel.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "payment_date", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var result: [Payment]!
        do {
            try result = moc.executeFetchRequest(fetchRequest) as? [Payment]
        } catch {
            fatalError("Error in fetching data \(error)")
        }
        
        return result
    }

    
    static func paymentfetchedRequest(year: Int) -> [Payment] {
        let moc = ListModel.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "payment_date", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "payment_date matches %@", "[0-9]{2}/[0-9]{1,2}/\(year)")
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var result: [Payment]!
        do {
            try result = moc.executeFetchRequest(fetchRequest) as? [Payment]
        } catch {
            fatalError("Error in fetching data \(error)")
        }
        
        return result
    }

    
}
