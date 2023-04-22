
//  contactsapp
//  Created by Dung Kim Nguyen. on 05/05/21.

import Foundation

/// Determines if this is the first time the app has been used.

enum FirstUsageManager {
    static func markAsUsed() {
        UserDefaults.standard.set(true, forKey: .opened)
    }
    static func checkIfAppsFirstUse()->Bool {
        return !UserDefaults.standard.bool(forKey: .opened)
    }
}
