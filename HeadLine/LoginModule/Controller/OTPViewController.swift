//
//  OTPViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 04/09/23.
//

import UIKit
import FirebaseAuth

class OTPViewController: UIViewController {
    
    @IBOutlet weak var firstField: PaddedTextField!
    @IBOutlet weak var otpContentView: UIView!
    @IBOutlet weak var otpErrorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var otpErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var otpValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if otpValue != "" && otpValue.count == 6 {
            let verifyId: String = (UserDefaults.standard.object(forKey: "authVerificationID") as? String)!
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyId, verificationCode: otpValue)
            if NetworkConnectionHandler().checkReachable() {
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        // Handle error
                        print("Error verifying OTP: \(error.localizedDescription)")
                        self.otpErrorLabelHeight.constant = 14
                        self.otpErrorLabel.text = "Please Enter a valid OTP"
                        return
                    }
                    
                    // OTP verification successful, the user is now authenticated
                    print("User authenticated: \(authResult?.user.uid ?? "N/A")")
                    if authResult?.user.uid != nil && authResult?.user.uid != "" {
                        self.goToHeadlines()
                    }
                }
            } else {
                let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    controller.dismiss(animated: true)
                    }
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            }
        } else {
            // empty field error
            otpErrorLabelHeight.constant = 14
            otpErrorLabel.text = "OTP is Required"
        }
    }
}

extension OTPViewController {
    func setUpUI() {
        loginButton.layer.cornerRadius = 10
        firstField.layer.cornerRadius = 5
        otpContentView.layer.cornerRadius = 5
        firstField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
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

extension OTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        otpErrorLabelHeight.constant = 0
        otpErrorLabel.text = ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        otpErrorLabelHeight.constant = 0
        otpErrorLabel.text = ""
        otpValue = textField.text ?? ""
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        otpValue = textField.text ?? ""
    }
}
