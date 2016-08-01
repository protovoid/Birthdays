//
//  CreateContactViewController.swift
//  Birthdays
//
//  Created by Gabriel Theodoropoulos on 27/9/15.
//  Modified by Chad Williams on 07/26/16.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import Contacts

class CreateContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFirstname: UITextField!
    
    @IBOutlet weak var txtLastname: UITextField!
    
    @IBOutlet weak var txtHomeEmail: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFirstname.delegate = self
        txtLastname.delegate = self
        txtHomeEmail.delegate = self
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(CreateContactViewController.createContact))
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Custom functions
    
    func createContact() {
        let newContact = CNMutableContact()
      
      newContact.givenName = txtFirstname.text!
      newContact.familyName = txtLastname.text!
      
      let homeEmail = CNLabeledValue(label: CNLabelHome, value: txtHomeEmail.text!)
      newContact.emailAddresses = [homeEmail]
      
      let birthdayComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: datePicker.date)
      newContact.birthday = birthdayComponents
      
      do {
        let saveRequest = CNSaveRequest()
        saveRequest.addContact(newContact, toContainerWithIdentifier: nil)
        try AppDelegate.getAppDelegate().contactStore.executeSaveRequest(saveRequest)
        
        navigationController?.popViewControllerAnimated(true)
      }
      catch {
        AppDelegate.getAppDelegate().showMessage("Unable to save the new contact.")
      }
      
    }
    

    // MARK: UITextFieldDelegate functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
