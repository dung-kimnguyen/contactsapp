
//  contactsapp
//  Created by Nocero Beguhe. on 05/05/21.

import UIKit

/// An object that indicates the type of change that happened to the ContactStore

enum ContactStoreUpdate {
    case added(indexPath: IndexPath)
    case updated(indexPath: IndexPath, contact: Contact)
    case deleted(indexPath: IndexPath)
}

// A repository of contacts for the app. Use this to fetch the initial list of contacts, as well as to add, edit, or delete a contact. The store sends notifications when it is updated and the apporpriate view controller subscribe to the notifications to update themselves.

class ContactsStore {
    
    var contacts: [Contact] {
        return coreDataController.fetchedResultsController?.fetchedObjects ?? [Contact]()
    }
    
    private lazy var coreDataController: CoreDataController = {
        return CoreDataController(delegate: self)
    }()
    
    // MARK: - Public
    
    func createContact(state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?, image: Data?) {
        coreDataController.createContact(state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode, image: image)
    }
    
    func update(contact: Contact, state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?, image: Data?) {
        coreDataController.edit(contact: contact, state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode, image: image)
    }
    
    func delete(contact: Contact) {
        coreDataController.delete(contact: contact)
    }
    
    // MARK: - Private
    
    private func addInitialContacts() {
        let json = JSONFetcher.fetchInitialContactsJSON()
        coreDataController.createContacts(from: json)
        FirstUsageManager.markAsUsed()
        fetchContacts()
    }
    
    private func fetchContacts() {
        coreDataController.fetchContacts()
    }
}

extension ContactsStore: CoreDataControllerDelegate {
    
    func coreDataControllerDidInitializeStores(_ controller: CoreDataController) {
        let isFirstUsage = FirstUsageManager.checkIfAppsFirstUse()
        isFirstUsage ? addInitialContacts() : fetchContacts()
    }
    
    func coreDataControllerDidFetchContacts(_ controller: CoreDataController) {
        NotificationCenter.default.post(name: .contactsFetched, object: nil)
    }
    
    func coreDataController(_ controller: CoreDataController, addedContactAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .contactUpdated, object: nil, userInfo: [String.contactStoreUpdate : ContactStoreUpdate.added(indexPath: indexPath)])
    }
    func coreDataController(_ controller: CoreDataController, updatedContact contact: Contact, at indexPath: IndexPath) {
        NotificationCenter.default.post(name: .contactUpdated, object: nil, userInfo: [String.contactStoreUpdate : ContactStoreUpdate.updated(indexPath: indexPath, contact: contact)])
    }
    
    func coreDataController(_ controller: CoreDataController, deletedContactAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .contactUpdated, object: nil, userInfo: [String.contactStoreUpdate : ContactStoreUpdate.deleted(indexPath: indexPath)])
    }
}
