//
//  LoginViewModel.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation

class LoginViewModal {
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$" // Assumes 10-digit phone numbers, adjust as needed
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}
