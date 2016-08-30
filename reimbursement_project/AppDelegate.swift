//
//  AppDelegate.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/20.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // set the managedObjectContext to viewController
        
//        let tabBarController = self.window!.rootViewController as! UITabBarController!
//        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController!
//        let viewController = navigationController.topViewController as! ViewController
//        viewController.managedObjectContext = self.managedObjectContext
        //test if there is data in the core data
        let moc = self.managedObjectContext
        let paymentFetch = NSFetchRequest(entityName: "Payment")
        var fetchedPayments: [Payment]
        do {
            fetchedPayments = try moc.executeFetchRequest(paymentFetch) as! [Payment]
        } catch {
            fatalError("Fail to fetch payments: \(error)")
        }
        
        if fetchedPayments.count > 0 {
            print("do not need to load the new data")
            return true // do not need to load the new data
        } else {
            print("need to load the data")
        }
        
        //load the data
        dbPath = NSBundle.mainBundle().pathForResource("reimbursement", ofType: "sqlite3")
        print(dbPath)
        db = openDatabase()
        query()
        updateCoreData()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "K.reimbursement_project" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("reimbursement_project", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    var todoItems:[(String, Double, String, String, String, String)] = Array()
    var dbPath: String!
    var db: COpaquePointer!
    
    
    let queryStatementString = "SELECT * FROM reimburse;"
    
    func query() {
        var queryStatement: COpaquePointer = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            todoItems = []
            var first_row_flag = true
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if first_row_flag == true {
                    first_row_flag = false
                    continue
                }
                let voucher_number_raw = sqlite3_column_text(queryStatement, 0)
                let amount_raw = sqlite3_column_text(queryStatement, 1)
                let payment_date_raw = sqlite3_column_text(queryStatement, 2)
                let vendor_name_raw = sqlite3_column_text(queryStatement, 3)
                let description_raw = sqlite3_column_text(queryStatement, 4)
                let department_name_raw = sqlite3_column_text(queryStatement, 5)
                let voucher_number = String.fromCString(UnsafePointer<CChar>(voucher_number_raw))!
                let amount = String.fromCString(UnsafePointer<CChar>(amount_raw))!
                let payment_date = String.fromCString(UnsafePointer<CChar>(payment_date_raw))!
                let vendor_name = String.fromCString(UnsafePointer<CChar>(vendor_name_raw))!
                let description = String.fromCString(UnsafePointer<CChar>(description_raw))!
                let department_name = String.fromCString(UnsafePointer<CChar>(department_name_raw))!
                
                let amount_double = Double((amount as NSString).substringFromIndex(1))!
                todoItems.append((voucher_number, amount_double, payment_date, vendor_name, description, department_name))
                print("\(voucher_number) | \(amount_double) | \(payment_date) | \(vendor_name) | \(description) | \(department_name)")
            }
        }
        sqlite3_finalize(queryStatement)
    }
    
    func openDatabase() -> COpaquePointer {
        var db: COpaquePointer = nil
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Database opened")
            return db
        } else {
            return nil
        }
    }
    
    
    func updateCoreData() {
        let moc = self.managedObjectContext
        for (voucher_number, amount, payment_date, vendor_name, description, department_name) in todoItems {
            let payment = NSEntityDescription.insertNewObjectForEntityForName("Payment", inManagedObjectContext: moc) as! Payment
            payment.voucher_number = voucher_number
            payment.amount = amount
            payment.payment_date = payment_date
            payment.mydescription = description
            //find vendor and department
            let vendorFetch = NSFetchRequest(entityName: "Vendor")
            vendorFetch.predicate = NSPredicate(format: "vendor_name = %@", vendor_name)
            let deptFetch = NSFetchRequest(entityName: "Department")
            deptFetch.predicate = NSPredicate(format: "department_name = %@", department_name)
            var vendorResult: [Vendor]
            var deptResult: [Department]
            do {
                try vendorResult = moc.executeFetchRequest(vendorFetch) as! [Vendor]
                try deptResult = moc.executeFetchRequest(deptFetch) as! [Department]
            } catch {
                fatalError("Error in fetching data \(error)")
            }
            
            if vendorResult.count > 0 && deptResult.count > 0{
                payment.vendor = vendorResult[0]
                payment.department = deptResult[0]
            } else if vendorResult.count > 0 && deptResult.count == 0 {
                payment.vendor = vendorResult[0]
                let department = NSEntityDescription.insertNewObjectForEntityForName("Department", inManagedObjectContext: moc) as! Department
                department.department_name = department_name
                department.vendors = department.vendors?.setByAddingObject(vendorResult[0])
                payment.department = department
                
            } else if vendorResult.count == 0 && deptResult.count > 0 {
                payment.department = deptResult[0]
                let vendor = NSEntityDescription.insertNewObjectForEntityForName("Vendor", inManagedObjectContext: moc) as! Vendor
                vendor.vendor_name = vendor_name
                vendor.department = deptResult[0]
                payment.vendor = vendor
            
            } else if vendorResult.count == 0 && deptResult.count == 0 {
                let vendor = NSEntityDescription.insertNewObjectForEntityForName("Vendor", inManagedObjectContext: moc) as! Vendor
                vendor.vendor_name = vendor_name
                let department = NSEntityDescription.insertNewObjectForEntityForName("Department", inManagedObjectContext: moc) as! Department
                department.department_name = department_name
                vendor.department = department
                department.vendors = department.vendors?.setByAddingObject(vendor)
                payment.department = department
                payment.vendor = vendor
                
            }
            
        }
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

}

