//
//  ViewController.swift
//  Birthdays
//
//  Created by Gabriel Theodoropoulos on 27/9/15.
//  Modified by Chad Williams on 07/26/16.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddContactViewControllerDelegate {
  
  @IBOutlet weak var tblContacts: UITableView!
  
  var contacts = [CNContact]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    navigationController?.navigationBar.tintColor = UIColor(red: 241.0/255.0, green: 107.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    
    configureTableView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      if identifier == "idSegueAddContact" {
        let addContactViewController = segue.destinationViewController as! AddContactViewController
        addContactViewController.delegate = self
      }
    }
  }
  
  
  // MARK: IBAction functions
  
  @IBAction func addContact(sender: AnyObject) {
    performSegueWithIdentifier("idSegueAddContact", sender: self)
  }
  
  
  // MARK: Custom functions
  
  func configureTableView() {
    tblContacts.delegate = self
    tblContacts.dataSource = self
    tblContacts.registerNib(UINib(nibName: "ContactBirthdayCell", bundle: nil), forCellReuseIdentifier: "idCellContactBirthday")
  }
  
  
  func refetchContact(contact contact: CNContact, atIndexPath indexPath: NSIndexPath) {
    AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
      if accessGranted {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        
        do {
          let contactRefetched = try AppDelegate.getAppDelegate().contactStore.unifiedContactWithIdentifier(contact.identifier, keysToFetch: keys)
          self.contacts[indexPath.row] = contactRefetched
          
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tblContacts.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          })
        }
        catch {
          print("Unable to refetch the contact: \(contact)", separator: "", terminator: "\n")
        }
      }
    }
  }
  
  
  
  // MARK: UITableView Delegate and Datasource functions
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //let cell = UITableViewCell()
    let cell = tableView.dequeueReusableCellWithIdentifier("idCellContactBirthday") as! ContactBirthdayCell
    
    let currentContact = contacts[indexPath.row]
    
    cell.lblFullname.text = "\(currentContact.givenName) \(currentContact.familyName)"
    
    if !currentContact.isKeyAvailable(CNContactBirthdayKey) || !currentContact.isKeyAvailable(CNContactImageDataKey) || !currentContact.isKeyAvailable(CNContactEmailAddressesKey) {
      refetchContact(contact: currentContact, atIndexPath: indexPath)
    }
    else {
      
      // set the birthday info.
      if let birthday = currentContact.birthday {
        cell.lblBirthday.text = "\(birthday.year)-\(birthday.month)-\(birthday.day)"
      }
      else {
        cell.lblBirthday.text = "Birthday data not available"
      }
      
      
      // set the contact image.
      if let imageData = currentContact.imageData {
        cell.imgContactImage.image = UIImage(data: imageData)
      }
      
      
      // set the contact's home email address.
      var homeEmailAddress: String!
      for emailAddress in currentContact.emailAddresses {
        if emailAddress.label == CNLabelHome {
          homeEmailAddress = emailAddress.value as! String
          break
        }
      }
      
      if homeEmailAddress != nil {
        cell.lblEmail.text = homeEmailAddress
      }
      else {
        cell.lblEmail.text = "Email not available"
      }
      
    }
    return cell
  }
  
  
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100.0
  }
  
  func didFetchContacts(contacts: [CNContact]) {
    for contact in contacts {
      self.contacts.append(contact)
    }
    tblContacts.reloadData()
  }
  
}

