//
//  AddContactViewController.swift
//  Birthdays
//
//  Created by Gabriel Theodoropoulos on 27/9/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

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
        return true
    }
    
    
    // MARK: Custom functions

    func performDoneItemTap() {
        
    }
}
