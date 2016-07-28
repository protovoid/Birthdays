//
//  AddContactViewController.swift
//  Birthdays
//
//  Created by Gabriel Theodoropoulos on 27/9/15.
//  Modified by Chad Williams on 07/26/16.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import Contacts

class AddContactViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var pickerMonth: UIPickerView!
    
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var currentlySelectedMonthIndex = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerMonth.delegate = self
        txtLastName.delegate = self
        
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "performDoneItemTap")
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: IBAction functions
    
    @IBAction func showContacts(sender: AnyObject) {
        
    }
 
    
    // MARK: UIPickerView Delegate and Datasource functions
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentlySelectedMonthIndex = row + 1
    }
    
    
    // MARK: UITextFieldDelegate functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
      AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
        if accessGranted {
          let predicate = CNContact.predicateForContactsMatchingName(self.txtLastName.text!)
          let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey]
          var contacts = [CNContact]()
          var message: String!
          
          let contactsStore = AppDelegate.getAppDelegate().contactStore
          do {
            contacts = try contactsStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
            
            if contacts.count == 0 {
              message = "No contacts were found matching the given name."
            }
          }
          catch {
            message = "Unable to fetch contacts."
          }
          
          
          if message != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              AppDelegate.getAppDelegate().showMessage(message)
          })
            else {
              // add code
            }
          
        }
      }
        return true
    }
    
    
    // MARK: Custom functions

    func performDoneItemTap() {
        
    }
}
