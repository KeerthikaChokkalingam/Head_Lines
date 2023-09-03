//
//  HeadLineModal.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation

class HeadLineModal {
    
}

struct HeadLinesResponse: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [ArticalSet]?
}

struct ArticalSet: Codable {
    var source: SourceStruct?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct SourceStruct: Codable {
    var id: String?
    var name: String?
}
