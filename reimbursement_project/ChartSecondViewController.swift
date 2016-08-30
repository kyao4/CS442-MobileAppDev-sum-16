//
//  ChartSecondViewController.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/23.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import UIKit


class ChartSecondViewController: UITableViewController {
    
    var category: String?
    var year: Int?
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ChartSecondCell")
        cell?.accessoryType = .DisclosureIndicator
        switch indexPath.row {
        case 0:
            if category == "By Date" {
                cell?.textLabel?.text = "Line Chart year: 2016"
            } else {
                cell?.textLabel?.text = "Bar Chart"
            }
            
        case 1:
            if category == "By Date" {
                cell?.textLabel?.text = "Line Chart year: 2015"
            } else {
                cell?.textLabel?.text = "Pie Chart"
            }
            
        default:
            cell?.textLabel?.text = ""
        }
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! ChartThirdViewController
        dest.category = self.category
        dest.chartType = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)?.textLabel?.text
        dest.year = Int((dest.chartType?.substringFromIndex(dest.chartType!.endIndex.advancedBy(-4)))!)
        dest.navigationItem.title = "Total amount \(category!)"
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
}