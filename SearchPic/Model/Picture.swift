//
//  Picture.swift
//  SearchPic
//
//  Created by Greg Deveaux on 18/06/2023.
//

import Foundation

struct Query: Codable {
    let total: Int
    let totalPages: Int
    let results: [Picture]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Picture: Codable {
    let id: String
    let description: String
    let urls: [URL]
}

struct URLImage: Codable {
    let dowload: String
    let large: String
    let medium: String
    let small: String

    enum CodingKeys: String, CodingKey {
        case dowload = "raw"
        case large = "regular"
        case medium = "small"
        case small = "thumb"
    }
}
