import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailText: FancyTextField!
    @IBOutlet weak var passwordText: FancyTextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Keychain.isUserAuthenticated() {
            showFeed()
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            if error != nil {
                print("Unable to auth with Facebook: \(error)")
            } else if result?.isCancelled == true {
                print("User canceled Facebook auth")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        })
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to auth with Firebase: \(error)")
            } else {
                print("Successfully authenticated with Firebase")
                self.completeSignIn(user)
            }
        })
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        let email = emailText.text!
        let password = passwordText.text!
        
        if !email.isEmpty && !password.isEmpty {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Successfully authenticated with email at Firebase")
                    self.completeSignIn(user)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to create user on Firebase: \(error)")
                        } else {
                            self.completeSignIn(user)
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(_ user: FIRUser?) {
        if let user = user {
            Keychain.saveUser(user)
        }
        showFeed()
    }
    
    func showFeed() {
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}
