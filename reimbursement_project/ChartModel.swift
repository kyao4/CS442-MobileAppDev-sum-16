//
//  ChartModel.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/24.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class ChartModel {
    
    static var managedObjectContext: NSManagedObjectContext  {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    
    
    static func getAmountSumWithDepartment() -> ([String], [Double]) {
    
        let moc = self.managedObjectContext
        // Build out our fetch request the usual way
        let request = NSFetchRequest(entityName: "Payment")
        // This is the column we are grouping by. Notice this is the only non aggregate column.
        request.propertiesToGroupBy = ["department"]

        
        var expressionDescriptions = [AnyObject]()
        // We want productLine to be one of the columns returned, so just add it as a string
        expressionDescriptions.append("department")
        
        // Create an expression description for our amount column
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "total_amount"
        expressionDescription.expression = NSExpression(format: "@sum.amount")
        expressionDescription.expressionResultType = .DoubleAttributeType
        expressionDescriptions.append(expressionDescription)
        request.propertiesToFetch = expressionDescriptions
        request.resultType = .DictionaryResultType
        let result: [Dictionary<String, AnyObject>]?
        do {
            try result = moc.executeFetchRequest(request) as? [Dictionary<String, AnyObject>]
        } catch {
            fatalError("Error in fetching data \(error)")
        }

        var department_name: [String] = Array()
        var total_amount: [Double] = Array()
        for item in result! {
            department_name.append((moc.objectWithID(item["department"] as! NSManagedObjectID) as! Department).department_name!)
            total_amount.append(item["total_amount"] as! Double)
        }

        
        return (department_name, total_amount)
    }
    
    
    
    static func getAmountSumWithPaymentDate(year: Int) -> ([String], [Double]) {
        
        let moc = self.managedObjectContext
        // Build out our fetch request the usual way
        let request = NSFetchRequest(entityName: "Payment")
        // This is the column we are grouping by. Notice this is the only non aggregate column.
        request.propertiesToGroupBy = ["payment_date"]
        
        
        let sortDescriptor = NSSortDescriptor(key: "payment_date", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "payment_date matches %@", "[0-9]{2}/[0-9]{1,2}/\(year)")
        var expressionDescriptions = [AnyObject]()
        // We want productLine to be one of the columns returned, so just add it as a string
        expressionDescriptions.append("payment_date")
        
        // Create an expression description for our amount column
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "total_amount"
        expressionDescription.expression = NSExpression(format: "@sum.amount")
        expressionDescription.expressionResultType = .DoubleAttributeType
        expressionDescriptions.append(expressionDescription)
        request.propertiesToFetch = expressionDescriptions
        request.resultType = .DictionaryResultType
        let result: [Dictionary<String, AnyObject>]?
        do {
            try result = moc.executeFetchRequest(request) as? [Dictionary<String, AnyObject>]
        } catch {
            fatalError("Error in fetching data \(error)")
        }
        
        var payment_date: [String] = Array()
        var total_amount: [Double] = Array()
        for item in result! {
            payment_date.append(item["payment_date"] as! String)
            total_amount.append(item["total_amount"] as! Double)
        }
        
        
        return (payment_date, total_amount)
    }
}