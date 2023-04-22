
//  contactsapp
//  Created by Dung Kim Nguyen. on 05/05/21.

import Foundation
import CoreData

/// Creates the FetchedResultsController used to populate the ContactsTableView via the ContactsStore

enum FetchedResultsControllerFactory {
    
    static func make(_ delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext)-> NSFetchedResultsController<Contact> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: .Contact)
        let firstNameSort = NSSortDescriptor(key: .sortDescriptorFirstName, ascending: true)
        let lastNameSort = NSSortDescriptor(key: .sortDescriptorLastName, ascending: true)
        request.sortDescriptors = [firstNameSort, lastNameSort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Contact>
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
}
