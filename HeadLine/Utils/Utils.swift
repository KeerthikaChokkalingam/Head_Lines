//
//  Utils.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation
import UIKit

class Utils {
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        let newUrl = URL(string: url)!
        URLSession.shared.dataTask(with: newUrl) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    func setUpLoader(sender: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = sender.center
        activityIndicator.color = UIColor.gray
        activityIndicator.tag = 444
        sender.addSubview(activityIndicator)
        return activityIndicator
    }
    func startLoading(sender: UIActivityIndicatorView, wholeView: UIView) {
        if let indicator = sender.viewWithTag(444) as? UIActivityIndicatorView {
            indicator.isHidden = false
            indicator.startAnimating()
        }
    }
    func endLoading(sender: UIActivityIndicatorView, wholeView: UIView) {
        if let indicator = sender.viewWithTag(444) as? UIActivityIndicatorView {
            indicator.isHidden = true
            indicator.hidesWhenStopped = true
            indicator.stopAnimating()
        }
    }
    
    func isValidURL(_ urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func convertUTCDateStringToFormattedDateString(utcDateString: String) -> String? {
        // Create a DateFormatter to specify the input format
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        // Set the time zone to UTC
        inputDateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        // Parse the input UTC date string
        guard let utcDate = inputDateFormatter.date(from: utcDateString) else {
            return nil // Return nil if the input string couldn't be parsed
        }
        
        // Create another DateFormatter to specify the output format
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Set the time zone to UTC for output as well (optional)
        outputDateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        // Use the output formatter to convert the UTC Date to a formatted String
        let formattedDateString = outputDateFormatter.string(from: utcDate)
        
        return formattedDateString
    }

}
