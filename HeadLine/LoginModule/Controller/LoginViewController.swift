//
//  ViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 02/09/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mobileNumberFiled: PaddedTextField!
    @IBOutlet weak var logInWithGoogleButton: UIButton!
    @IBOutlet weak var loginContentView: UIView!
    
    var accessToken: String = ""
    var idToken: String = ""
    var loginViewModel: LoginViewModal?
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func logInWithGoogleAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self) { [weak self] signInResult, error in
                guard let result = signInResult else { return }
                self?.accessToken = (GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString)!
                self?.idToken = (GIDSignIn.sharedInstance.currentUser?.idToken!.tokenString)!
                
                
                let name = result.user.profile?.name ?? ""
                let email = result.user.profile?.email ?? ""
                let profileImageURL = result.user.profile?.imageURL(withDimension: 120)?.absoluteString ?? ""
                
                // Create a reference to your Firestore database
                let db = Firestore.firestore()
                
                // Create a document reference for the user using their UID
                if let uid = result.user.userID {
                    let userRef = db.collection("HeadLines").document(uid)
                    // Data to be saved
                    let userData: [String: Any] = [
                        "name": name,
                        "email": email,
                        "profileImageURL": profileImageURL,
                    ]
                    userRef.setData(userData) { error in
                        if let error = error {
                            print("Error saving user data: \(error.localizedDescription)")
                        } else {
                            self?.goToHeadlines()
                            print("User data saved successfully")
                        }
                    }
                    
                }
                
            }
    }
    
}

extension LoginViewController {
    func setUpUI() {
        loginContentView.layer.cornerRadius = 10
        logInWithGoogleButton.layer.cornerRadius = 15
        mobileNumberFiled.placeholder = "Enter Valid Mobile Number"
        mobileNumberFiled.addPadding(left: 10, right: 10)
    }
    func goToHeadlines() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HeadLinesViewController") as? HeadLinesViewController
        guard let scene = UIApplication.shared.connectedScenes.first, let sceneDelegate = scene.delegate as? SceneDelegate else {
            fatalError("Could not get scene delegate!")
        }
        sceneDelegate.window?.rootViewController = secondViewController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
