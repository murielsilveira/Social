import UIKit
import Firebase

class FeedVC: UIViewController {

    @IBAction func signOutTapped(_ sender: UIButton) {
        Keychain.signOut()
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
