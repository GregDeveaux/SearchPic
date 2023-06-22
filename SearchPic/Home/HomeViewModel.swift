//
//  HomeViewModel.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import Foundation

class HomeViewModel: ObservableObject {

        // MARK: - wrapper properties
    @Published var searchWord: String = ""
    @Published var pictures: [Picture] = []

        // allows to have pictures at launch app chosen random in this list (into French 🇫🇷)
    @Published var randomSearchAtLaunchApp: [String] = ["code", "plage", "disque vinyle", "basketball", "licorne", "chat", "chien", "dragon", "boombox"]

        // page number for the pictures group
    @Published var currentPageAPI: Int = 1
    @Published var pictureNumberPerPage: Int = 10
    @Published var numberTotalPictureDisplayed: Int = 1

        // MARK: - search pictures with word
    func searchPictures(with word: String) async throws {

        let url = createUrl(with: word)

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

        // MARK: - adds the images in the list
    @MainActor
    func saveThePictures(query: Query) {
        for result in query.results {
            let picture = Picture(id: result.id, description: result.description, urls: result.urls)
            self.pictures.append(picture)
        }
        print ("✅ HOME_VIEW_MODEL/GET_PICTURE: there is \(self.pictures.count) pictures founded")
        dump(self.pictures)
    }

    @MainActor
    func getOtherPicturesPages(currentIndexPicture: Int) async throws {
        print("✅ HOME_VIEW_MODEL/GET_OTHER_PICTURES_PAGES: 📑 Current Page API unsplash -> \(currentPageAPI)")
        print("✅ HOME_VIEW_MODEL/GET_OTHER_PICTURES_PAGES: 🌆 Current number of series -> \(currentIndexPicture)")

        if currentIndexPicture == pictureNumberPerPage - 3 {
            currentPageAPI += 1
            pictureNumberPerPage += 10
            try await searchPictures(with: searchWord)
            print("✅ HOME_VIEW_MODEL/GET_OTHER_PICTURES_PAGES: 📑🌆 Current picture number max before reload the new pictures of the word -> \(pictureNumberPerPage)")
        }
    }

        // create the url for the word
    func createUrl(with word: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPageAPI)"),
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
}
