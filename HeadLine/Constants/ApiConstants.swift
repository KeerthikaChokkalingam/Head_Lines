//
//  ApiConstants.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation

class ApiConstants {
    public static var domainUrl: String = "https://newsapi.org/v2/everything?q=apple&from=2023-09-02&to=2023-09-03&sortBy=popularity&apiKey="
    public static var accessKey: String = "da4453789d80491b803502f1af766646"
    public static var sourceUrl: String = domainUrl + accessKey
}
