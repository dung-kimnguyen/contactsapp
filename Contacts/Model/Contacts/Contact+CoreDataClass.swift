
//  contactsapp
//  Created by Nocero Beguhe. on 05/05/21.

import Foundation
import CoreData

/// A Contact is models a contact card that shows information about the user's connections

@objc(Contact)
public class Contact: NSManagedObject {}

extension Contact {
    var displayName: String {
        if let firstName = firstName, let lastName = lastName {
            return firstName + " " + lastName
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else if let phoneNumber = phoneNumber {
            return phoneNumber
        } else {
            return "NA"
        }
    }
}
