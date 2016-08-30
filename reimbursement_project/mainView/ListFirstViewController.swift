//
//  listFirstViewController.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/29.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class ListFirstViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var sortBy = ""
    var fetchedResults:[Payment] = []
    var departmentList: [String]?
    var dateList: [String]?
    override func viewDidLoad() {
        
        print("Sort by " + sortBy)
        switch sortBy {
        case "By Department":
            departmentList = []
            fetchedResults = ListModel.paymentfetchedRequest()
            for payment in fetchedResults {
                if !departmentList!.contains((payment.department?.department_name!)!) {
                    departmentList!.append((payment.department?.department_name!)!)
                    print(payment.department?.department_name!)
                }

            }
        case "By Date":
            dateList = []
            fetchedResults = ListModel.paymentfetchedRequest(2015)
            fetchedResults.appendContentsOf(ListModel.paymentfetchedRequest(2016))
            for payment in fetchedResults {
                if !dateList!.contains(payment.payment_date!) {
                    dateList!.append(payment.payment_date!)
                    print(payment.payment_date!)
                }
            }
            
        default:
            print("fetched result error!")
        }
    }
    
    
    func configureCell(cell: UITableViewCell, with object: String) {
        cell.textLabel!.text = object
    }
    
    
    // MARK: - Table View
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((departmentList ?? dateList)?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("listFirstCell")
            configureCell(cell!, with: (departmentList ?? dateList!)[indexPath.row])
        
        return cell!
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! ListSecondViewController
        dest.paymentList = fetchedResults
        dest.seletedItem = (tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!))?.textLabel?.text
        dest.sortBy = self.sortBy
        dest.navigationItem.title = "Item List"
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
    }
    
}