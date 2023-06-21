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

        // allows to have pictures at launch app chosen random in this list (into French 🇫🇷)
    @Published var randomSearchAtLaunchApp: [String] = ["code", "plage", "disque vinyle", "basketball", "licorne", "chat", "chien", "dragon", "boombox"]

        // number of picture page
    @Published var page: Int = 1
    

        // MARK: - search pictures with word
    func searchPictures(with word: String) async throws {

            // create the url for the word
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.unsplash.com"
            components.path = "/search/photos"
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "lang", value: "fr"),
                URLQueryItem(name: "query", value: "\(word)"),
                URLQueryItem(name: "client_id", value: "zQzGRjojH3JNE-S9qLgcGmfzvZbp9NrT6ZlzqXKny6c")
            ]

            guard let url = components.url else {
                preconditionFailure("🛑 HOME_VIEW_MODEL/GET_PICTURE: \(SearchPictureError.invalidUrl)")
            }

            print("✅ HOME_VIEW_MODEL/GET_PICTURE: the search word is: \(word)")
            print("✅ HOME_VIEW_MODEL/GET_PICTURE: the url used to search pictures is: \(url)")

            return url
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SearchPictureError.invalidResponse
        }

        do {
            print("✅ QUERY_SERVICE: the task received \(String(data: data, encoding: .utf8)!)")

            let decoder = JSONDecoder()
            let query = try decoder.decode(Query.self, from: data)

            await saveThePictures(query: query)
        }
        catch {
            print("🛑 Decoding error: \(error)")
            throw SearchPictureError.invalidData
        }
    }

    @MainActor
    func saveThePictures(query: Query) {
        for result in query.results {
            let picture = Picture(id: result.id, description: result.description, urls: result.urls)
            self.pictures.append(picture)
        }
        print ("✅ HOME_VIEW_MODEL/GET_PICTURE: there is \(self.pictures.count) pictures founded")
        dump(self.pictures)
    }
}
