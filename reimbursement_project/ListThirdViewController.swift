//
//  ListThirdViewController.swift
//  reimbursement_project
//
//  Created by Chuanwei Tu on 6/29/16.
//  Copyright © 2016 Kai Yao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListThirdViewController: UIViewController {
    
    
    var currentItem: Payment?
    
    @IBOutlet var voucher_number_text: UITextField!
    @IBOutlet var date_text: UITextField!
    @IBOutlet var amount_text: UITextField!
    @IBOutlet var dept_text: UITextView!
    @IBOutlet var vendor_text: UITextView!
    @IBOutlet var description_text: UITextView!
    
    
    
    override func viewDidLoad() {
        voucher_number_text.userInteractionEnabled = false
        date_text.userInteractionEnabled = false
        amount_text.userInteractionEnabled = false
        dept_text.userInteractionEnabled = false
        vendor_text.userInteractionEnabled = false
        description_text.userInteractionEnabled = false
        description_text.scrollEnabled = true
        
        
        
        voucher_number_text.text = currentItem?.voucher_number
        date_text.text = currentItem?.payment_date
        amount_text.text = String(format: "%.2f", Double((currentItem?.amount)!))
        dept_text.text = currentItem?.department?.department_name
        vendor_text.text = currentItem?.vendor?.vendor_name
        description_text.text = currentItem?.mydescription
    }
    
    
    @IBAction func touch(sender: UITapGestureRecognizer) {
        voucher_number_text.resignFirstResponder()
        date_text.resignFirstResponder()
        amount_text.resignFirstResponder()
        dept_text.resignFirstResponder()
        vendor_text.resignFirstResponder()
        description_text.resignFirstResponder()
    }
    
    
    
}