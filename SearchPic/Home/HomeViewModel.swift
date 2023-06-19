//
//  HomeViewModel.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import Foundation

class HomeViewModel: ObservableObject {

        // MARK: - wrapper properties
    @Published var searchText: String = ""
    @Published var pictures: [Picture] = []
    @Published var page: Int = 1

        // MARK: - getPictures
    func getPictures() async throws -> Picture {
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.unsplash.com"
            components.path = "/search/photos"
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "lang", value: "fr"),
                URLQueryItem(name: "query", value: "\(searchText)"),
                URLQueryItem(name: "client_id", value: "zQzGRjojH3JNE-S9qLgcGmfzvZbp9NrT6ZlzqXKny6c")
            ]

            guard let url = components.url else {
                preconditionFailure("🛑 HOME_VIEW_MODEL/GET_PICTURE: Invalid URL components")
            }
            return url
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SearchPictureError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            let pictures = try decoder.decode(Picture.self, from: data)
            print ("✅ HOME_VIEW_MODEL/GET_PICTURE: \(pictures)")

            return pictures
        }
        catch {
            throw SearchPictureError.invalidData
        }
    }
}
