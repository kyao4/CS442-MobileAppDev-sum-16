//
//  ChartFirstViewController.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/23.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import UIKit


class ChartFirstViewController: UITableViewController {
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ChartFirstCell")
        cell?.accessoryType = .DisclosureIndicator
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "By Department"
        case 1:
            cell?.textLabel?.text = "By Date"
        default:
            cell?.textLabel?.text = ""
        }
        
        return cell!
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! ChartSecondViewController
        dest.category = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)?.textLabel?.text
        dest.navigationItem.title = "Chart Type"
    }
}