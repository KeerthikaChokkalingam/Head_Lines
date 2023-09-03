//
//  ExtensionConstants.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation
import UIKit

class ExtensionConstants {
}
extension UITextField {
    func addPadding(left: CGFloat, right: CGFloat) {
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))

        self.leftView = paddingViewLeft
        self.leftViewMode = .always

        self.rightView = paddingViewRight
        self.rightViewMode = .always
    }
}
