
//  contactsapp
//  Created by Dung Kim Nguyen. on 05/05/21.

import Foundation

/// Used to replace the 'stringly typed' APIs in Cocoa.

extension String {
    
    // MARK: - Segues
    
    static let segueFromContactsToAddContact = "segueFromContactsToAddContact"
    static let segueFromContactsToContactDetail = "segueFromContactsToContactDetail"
    static let segueFromDetailToForm = "segueFromDetailToForm"
    
    // MARK: - UserDefaults
    
    static let opened = "opened"
    
    // MARK: - Bundle
    
    static let contacts = "contacts"
    static let json = "json"
    
    // MARK: - CoreData Entity
    
    static let Contact = "Contact"
    
    // MARK: - CoreData Model
    
    static let Model = "Model"
    
    // MARK: - CoreData SortDescriptor
    
    static let sortDescriptorFirstName = "firstName"
    static let sortDescriptorLastName = "lastName"
    
    // MARK: - NotificationCenter UserInfo
    
    static let contactStoreUpdate = "contactStoreUpdate"
    
    // MARK: - TableViewCellIdentifier
    
    static let contactCell = "contactCell"
    
    // MARK: - JSON Keys
    
    static let contactID = "contactID"
    static let state = "state"
    static let city = "city"
    static let streetAddress1 = "streetAddress1"
    static let streetAddress2 = "streetAddress2"
    static let phoneNumber = "phoneNumber"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let zipcode = "zipcode"
    static let image = "image"
    
    // MARK: = Localized Strings
    static let addContact = NSLocalizedString("Add Contact", comment: "Title for the form view controller in the .new state")
    static let editContact = NSLocalizedString("Edit Contact", comment: "Title for the form view controller in the .update state")
}

