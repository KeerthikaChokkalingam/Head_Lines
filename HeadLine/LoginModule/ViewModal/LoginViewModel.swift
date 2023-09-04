//
//  LoginViewModel.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation

class LoginViewModal {
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}
