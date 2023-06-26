//
//  HomeViewModel.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

        // MARK: - wrapper properties
    @Published var searchWord: String = ""
    @Published var pictures: [Picture] = []

        // allows to have pictures at launch app chosen random in this list (in French 🇫🇷)
    @Published var randomSearchAtLaunchApp: [String] = ["code", "plage", "disque vinyle", "basketball", "licorne", "chat", "chien", "dragon", "boombox"]

        // page number for the pictures group
    @Published var currentPageAPI: Int = 1
    @Published var pictureNumberPerPage: Int = 10
    @Published var numberTotalOfPicturesPossible: Int = 1

    @Published var numberOfColumns: Int = 1
    @Published var columns: [GridItem] = []


        //MARK: - property
        // uses to change columns number of the grid
    let gridItem = GridItem(.flexible(),spacing: 20)


        // MARK: - searchPictures
        /// Description: Allows to search whole pictures with keyword
        /// - Parameter word: word indicates in the seachBar
    func searchPictures(with keyWord: String) async throws {

        let url = createUrl(with: keyWord)

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
                case 200:
                    do {
                        print("✅ QUERY_SERVICE: the task received \(String(data: data, encoding: .utf8)!)")

                        let decoder = JSONDecoder()
                        let query = try decoder.decode(Query.self, from: data)

                        await saveThePictures(query: query)
                    }
                    catch {
                        print("🛑 Decoding error: \(String(describing: SearchPictureError.invalidData.errorDescription))")
                        throw SearchPictureError.invalidData
                    }
                case 400...451:
                    print("🛑 Decoding error: \(String(describing: SearchPictureError.invalidUrl.errorDescription))")
                    throw SearchPictureError.invalidUrl

                case 500...511:
                    print("🛑 Decoding error: \(String(describing: SearchPictureError.invalidResponse.errorDescription))")
                    throw SearchPictureError.invalidResponse

                default:
                    return
            }
        }
    }


        // MARK: - saveThePictures
    @MainActor
        /// Description: Allows to save, in the main thread, the found pictures in the array for the scrollView
        /// - Parameter query: results found in the func searchPictures(with: "")
    func saveThePictures(query: Query) {
        for result in query.results {
            let picture = Picture(id: result.id, description: result.description, user: .init(name: result.user.name), urls: result.urls)
            self.pictures.append(picture)
        }
        print ("✅ HOME_VIEW_MODEL/GET_PICTURE: there is \(self.pictures.count) pictures founded")
        dump(self.pictures)
    }


        // MARK: - getOtherPicturesPages
    @MainActor
        /// Description: Allows to retrieve the other pictures after the next page API in the main thread
        /// - Parameter currentIndexPictureDisplayed: number of current index of the picture in the list
    func getOtherPicturesPages(currentIndexPictureDisplayed: Int) async throws {
        print("✅ HOME_VIEW_MODEL/GET_OTHER_PICTURES_PAGES: 📑 Current Page API unsplash -> \(currentPageAPI)")
        print("✅ HOME_VIEW_MODEL/GET_OTHER_PICTURES_PAGES: 🌆 Current number of series -> \(currentIndexPictureDisplayed)")

        if currentIndexPictureDisplayed >= pictureNumberPerPage - 3 {
            currentPageAPI += 1
            pictureNumberPerPage += 10
            try await searchPictures(with: searchWord)
            print("✅ HOME_VIEW_MODEL/GET_OTHER_PICTURES_PAGES: 📑🌆 Current picture number max before reload the new pictures of the word -> \(pictureNumberPerPage)")
        }
    }


        // MARK: - createUrl
        /// Description: Allows to create the url of the API for the keyword writted
        /// - Parameter word: keyword seached
        /// - Returns: url of API Unsplash
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


        // MARK: - ChangeNumberOfColumns
        /// Description: Allows to change the presentation of the pictures grid
        /// - Parameter number: number of columns that we wish to show
    func ChangeNumberOfColumns(_ number: Int) {
        columns.removeAll()

        numberOfColumns = number

        columns.append(contentsOf: repeatElement(gridItem, count: numberOfColumns))
        
        print("✅ HOME_VIEW/ON_APPEAR: change the number of columns at \(numberOfColumns) ")
    }


        // MARK: - resetSearchPicture
        /// Description: Allows to reset counters for API image searches
    func resetSearchPicture() {
        pictures.removeAll()
        currentPageAPI = 1
        pictureNumberPerPage = 10
    }
}
