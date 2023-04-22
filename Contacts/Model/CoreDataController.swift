
//  contactsapp
//  Created by Dung Kim Nguyen. on 05/05/21.

import UIKit
import CoreData

protocol CoreDataControllerDelegate: class {
    func coreDataControllerDidInitializeStores(_ controller: CoreDataController)
    func coreDataControllerDidFetchContacts(_ controller: CoreDataController)
    func coreDataController(_ controller: CoreDataController, addedContactAt indexPath: IndexPath)
    func coreDataController(_ controller: CoreDataController, updatedContact contact: Contact, at indexPath: IndexPath)
    func coreDataController(_ controller: CoreDataController, deletedContactAt indexPath: IndexPath)
}

/// Manages the adding, editing and deleting of NSManagedObjects as instructed by the ContactStore.

class CoreDataController: NSObject {
    
    var fetchedResultsController: NSFetchedResultsController<Contact>?
    private let persistentContainer = NSPersistentContainer(name: .Model)
    private weak var delegate: CoreDataControllerDelegate!
    
    init(delegate: CoreDataControllerDelegate) {
        self.delegate = delegate
        
        super.init()
        persistentContainer.loadPersistentStores() { [weak self](description, error) in
            guard let this = self else { return }
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            this.initializeFetchedResultsController()
            DispatchQueue.main.async {
                this.delegate.coreDataControllerDidInitializeStores(this)
            }
        }
    }
    
    func createContacts(from jsonCollection: [Any]) {
        jsonCollection.forEach { createContact(from: $0 as! [String: Any]) }
        saveContext()
    }
    
    func createContact(state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?, image: Data?, contactID: String = UUID().uuidString) {
        
        insertContactInContext(state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode, image: image, contactID: contactID)
        saveContext()
    }
    
    func edit(contact: Contact, state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?, image: Data?) {
        update(contact, contactID: contact.contactID, state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode, image: image)
        saveContext()
    }
    
    func delete(contact: Contact) {
        persistentContainer.viewContext.delete(contact)
        saveContext()
    }
    
    func fetchContacts() {
        do {
            try fetchedResultsController?.performFetch()
            delegate.coreDataControllerDidFetchContacts(self)
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - Private
    
    private func initializeFetchedResultsController() {
        fetchedResultsController = FetchedResultsControllerFactory.make(self, context: persistentContainer.viewContext)
    }
    
    private func createContact(from json: [String: Any]) {
        guard let contactID = json[.contactID] as? String else { return }
        let state = json[.state] as? String
        let city = json[.city] as? String
        let streetAddress1 = json[.streetAddress1] as? String
        let streetAddress2 = json[.streetAddress2] as? String
        let phoneNumber = json[.phoneNumber] as? String
        let firstName = json[.firstName] as? String
        let lastName = json[.lastName] as? String
        let zipcode = json[.zipcode] as? String
        let image = json[.image] as? Data
        
        insertContactInContext(state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode, image: image, contactID: contactID)
    }
    
    private func insertContactInContext(state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?, image: Data?, contactID: String) {
        let contact = NSEntityDescription.insertNewObject(forEntityName: .Contact, into: persistentContainer.viewContext) as! Contact
        update(contact, contactID: contactID, state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode, image: image)
    }
    
    private func update(_ contact: Contact, contactID: String, state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?, image: Data?) {
        contact.contactID = contactID
        contact.state = state
        contact.city = city
        contact.streetAddress1 = streetAddress1
        contact.streetAddress2 = streetAddress2
        contact.phoneNumber = phoneNumber
        contact.firstName = firstName
        contact.lastName = lastName
        contact.zipcode = zipcode
        contact.image = image
    }
    
    private func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}

extension CoreDataController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { fatalError() }
            delegate.coreDataController(self, addedContactAt: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            delegate.coreDataController(self, deletedContactAt: indexPath)
        case .move:
            return
        case .update:
            guard let contact = anObject as? Contact,
                let newIndexPath = newIndexPath else { fatalError() }
            delegate.coreDataController(self, updatedContact: contact, at: newIndexPath)
        }
    }
}
