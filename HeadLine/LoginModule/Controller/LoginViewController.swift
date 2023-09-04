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
    
    @IBOutlet weak var mobileFieldErrorLabel: UILabel!
    @IBOutlet weak var mobileErrorLabelHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var mobileNumberFiled: PaddedTextField!
    @IBOutlet weak var logInWithGoogleButton: UIButton!
    @IBOutlet weak var loginContentView: UIView!
    
    var accessToken: String = ""
    var idToken: String = ""
    var loginViewModel: LoginViewModal?
    var mobileNumberFieldvalue: String = ""
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
    @IBAction func getCodeAction(_ sender: UIButton) {
        view.endEditing(true)
        loginViewModel = LoginViewModal()
        if mobileNumberFieldvalue != "" {
            if ((loginViewModel?.isValidPhoneNumber(mobileNumberFieldvalue)) != nil) {
                // Start phone number verification
                let phoneNum = "+91" + mobileNumberFieldvalue
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print("Error sending verification code: \(error.localizedDescription)")
                        return
                    }
                    // Save the verification ID for later use
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self.goToOtpScreen()
                    // Proceed to the verification code entry screen
                }
            }else {
                //not a valid mobile number through error
                errorExists(errorLabelString: "  Not a Valid Mobile Number  ")
            }
        } else {
            // mobile number field is empty through error
            errorExists(errorLabelString: "  This field is Required  ")
        }
    }
    
    func errorExists(errorLabelString: String) {
        mobileFieldErrorLabel.text = errorLabelString
        if let logInContentHeightChange = loginContentView.constraints.filter({$0.firstAttribute == .height}).first {
            logInContentHeightChange.constant = 400
        }
        mobileErrorLabelHeightAnchor.constant = 14
    }
    func normalHeight(errorLabelString: String) {
        mobileFieldErrorLabel.text = errorLabelString
        if let logInContentHeightChange = loginContentView.constraints.filter({$0.firstAttribute == .height}).first {
            logInContentHeightChange.constant = 384
        }
        mobileErrorLabelHeightAnchor.constant = 0
    }
}

extension LoginViewController {
    func setUpUI() {
        mobileNumberFieldvalue = mobileNumberFiled.text ?? ""
        loginContentView.layer.cornerRadius = 10
        getCodeButton.layer.cornerRadius = 10
        logInWithGoogleButton.layer.cornerRadius = 15
        mobileNumberFiled.placeholder = "Enter Valid Mobile Number"
        mobileNumberFiled.addPadding(left: 10, right: 10)
        mobileNumberFiled.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    func sendVerificationCode(to phoneNumber: String, completion: @escaping (Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(error)
                return
            }
            // Save the verificationID for later use
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(nil)
        }
    }
    func goToHeadlines() {
        guard let detaildHeadLineVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeadLinesViewController") as? HeadLinesViewController else {return}
        self.navigationController?.pushViewController(detaildHeadLineVc, animated: true)
    }
    func goToOtpScreen() {
        guard let detaildHeadLineVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController else {return}
        self.navigationController?.pushViewController(detaildHeadLineVc, animated: true)
    }
    func verifySMSCode(_ code: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    completion(nil, error)
                } else if let authResult = authResult {
                    completion(authResult, nil)
                }
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Verification ID not found."])
            completion(nil, error)
        }
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        normalHeight(errorLabelString: "")
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        normalHeight(errorLabelString: "")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mobileNumberFieldvalue = textField.text ?? ""
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        mobileNumberFieldvalue = textField.text ?? ""
    }
}
