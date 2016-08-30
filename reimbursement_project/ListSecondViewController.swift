//
//  ListSecondViewController.swift
//  reimbursement_project
//
//  Created by Chuanwei Tu on 6/29/16.
//  Copyright © 2016 Kai Yao. All rights reserved.
//

import Foundation
import UIKit

class ListSecondViewController: UITableViewController {
    
    
    var paymentList: [Payment]?
    var sortBy: String?
    var seletedItem: String?
    var currentPayment: [Payment]?
    override func viewDidLoad() {
        currentPayment = []
        switch sortBy! {
        case "By Department":
            for payment in paymentList! {
                if payment.department?.department_name == seletedItem {
                    currentPayment?.append(payment)
                }
            }
        case "By Date":
            for payment in paymentList! {
                if payment.payment_date == seletedItem {
                    currentPayment?.append(payment)
                }
            }
        default:
            print("sort by error")
        }
        print(currentPayment)
    }
    
    func configureCell(cell: UITableViewCell, with Object: Payment) {
        cell.textLabel?.text = Object.voucher_number! + " $" + String(format: "%.2f", Double(Object.amount!))
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentPayment?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listSecondCell")
        configureCell(cell!, with: currentPayment![indexPath.row])
        return cell!
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! ListThirdViewController
        dest.navigationItem.title = "Item"
        dest.currentItem = self.currentPayment![(tableView.indexPathForSelectedRow?.row)!]
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
    
    
    }
    
}