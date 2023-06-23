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
    let description: String?
    let user: Photographer
    let urls: UrlsImage
}

struct Photographer: Codable {
    let name: String?
}

struct UrlsImage: Codable {
    let download: String
    let largeSize: String
    let mediumSize: String
    let smallSize: String

    enum CodingKeys: String, CodingKey {
        case download = "raw"
        case largeSize = "regular"
        case mediumSize = "small"
        case smallSize = "thumb"
    }
}

    // allows to simulate the data pictures without to use API for preview
extension Picture {
    static var examples: [Picture] = [
        Picture(
            id: "fbbxMwwKqZk",
            description: nil,
            user: Photographer(name: "Boxed Water Is Better"),
            urls: UrlsImage(
                download: "https://images.unsplash.com/photo-1564419320461-6870880221ad?ixid=M3w0NjI4NDV8MXwxfHNlYXJjaHwxfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3",
                largeSize: "https://images.unsplash.com/photo-1564419320461-6870880221ad?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MXwxfHNlYXJjaHwxfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=1080",
                mediumSize: "https://images.unsplash.com/photo-1564419320461-6870880221ad?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MXwxfHNlYXJjaHwxfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=400",
                smallSize: "https://images.unsplash.com/photo-1564419320461-6870880221ad?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MXwxfHNlYXJjaHwxfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=200")),
        Picture(
            id: "KMn4VEeEPR8",
            description: "The last night of a two week stay on the North Shore of Oahu, Hawaii.",
            user: Photographer(name: "Sean Oulashin"),
            urls: UrlsImage(
                download: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3",
                largeSize: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=1080",
                mediumSize: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=400",
                smallSize: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=200")),
        Picture(
            id: "DH_u2aV3nGM",
            description: nil,
            user: Photographer(name: "Matthew Brodeur"),
            urls: UrlsImage(
                download: "https://images.unsplash.com/photo-1509233725247-49e657c54213?ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwzfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3",
                largeSize: "https://images.unsplash.com/photo-1509233725247-49e657c54213?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwzfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=1080",
                mediumSize: "https://images.unsplash.com/photo-1509233725247-49e657c54213?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwzfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=400",
                smallSize: "https://images.unsplash.com/photo-1509233725247-49e657c54213?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwzfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=200")),
        Picture(
            id: "d7M5Xramf8g",
            description: "San Lorenzo sunset reflected in the sea",
            user: Photographer(name: "Akin Cakiner"),
            urls: UrlsImage(
                download: "https://images.unsplash.com/photo-1473116763249-2faaef81ccda?ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHw0fHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3",
                largeSize: "https://images.unsplash.com/photo-1473116763249-2faaef81ccda?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHw0fHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=1080",
                mediumSize: "https://images.unsplash.com/photo-1473116763249-2faaef81ccda?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHw0fHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=400",
                smallSize: "https://images.unsplash.com/photo-1473116763249-2faaef81ccda?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHw0fHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=200"))
    ]
}
