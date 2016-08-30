//
//  ViewController.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/20.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    var sortBy = ""
    
    
    var managedObjectContext: NSManagedObjectContext! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //load payment objects

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "By Department"
        case 1:
            cell.textLabel?.text = "By Date"
        default:
            print("Error with table")
            
        }
        return cell
    }
    
    
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return self.fetchedResultsController.sections?.count ?? 0
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo = self.fetchedResultsController.sections![section]
//        return sectionInfo.numberOfObjects
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath)
//        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Payment
//        self.configureCell(cell, with: object)
//        return cell
//    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! ListFirstViewController
        self.sortBy = ((tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!))?.textLabel?.text)!
        dest.sortBy = self.sortBy
        dest.navigationItem.title = "Range"
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
    }
    
    


}

