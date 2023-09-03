//
//  ViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 02/09/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logInWithAppleButton: UIButton!
    @IBOutlet weak var logInWithGoogleButton: UIButton!
    @IBOutlet weak var loginContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func logInWithGoogleAction(_ sender: UIButton) {
        
    }
    
    @IBAction func logInWithAppleButton(_ sender: UIButton) {
        
    }
}

extension LoginViewController {
    func setUpUI() {
        loginContentView.layer.cornerRadius = 10
        logInWithAppleButton.layer.cornerRadius = 15
        logInWithGoogleButton.layer.cornerRadius = 15
    }
    func goToHeadlines() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        guard let scene = UIApplication.shared.connectedScenes.first, let sceneDelegate = scene.delegate as? SceneDelegate else {
            fatalError("Could not get scene delegate!")
        }
        sceneDelegate.window?.rootViewController = secondViewController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
