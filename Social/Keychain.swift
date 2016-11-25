import Firebase
import SwiftKeychainWrapper

class Keychain {
    static let USER_UID_KEY = "user_uid"
    
    static func saveUser(_ user: FIRUser) {
        _ = KeychainWrapper.setString(user.uid, forKey: self.USER_UID_KEY)
    }
    
    static func isUserAuthenticated() -> Bool {
        if let _ = KeychainWrapper.stringForKey(self.USER_UID_KEY) {
            return true
        } else {
            return false
        }
    }
    
    static func signOut() {
        _ = KeychainWrapper.removeObjectForKey(self.USER_UID_KEY)
    }
}
