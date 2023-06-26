//
//  SearchPicTests.swift
//  SearchPicTests
//
//  Created by Greg Deveaux on 25/06/2023.
//

import XCTest
@testable import SearchPic

final class SearchPicTests: XCTestCase {

    var searchWord = "plage"
    lazy var urlOfsearchWord: String = {
        return "https://api.unsplash.com/search/photos?page=1&lang=fr&query=\(searchWord)&client_id=zQzGRjojH3JNE-S9qLgcGmfzvZbp9NrT6ZlzqXKny6c"
    }()

    var viewModel: HomeViewModel?

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }


        //MARK: - test HomeViewModel/getOtherPicturesPages
    
    func test_GivenTheGoodIndexToActivateThisMethod_ThenNewsPicturesDisplayByANewCallUrlOfPage() async throws {

        let currentIndex = 8
        let currentPageAPI = viewModel?.currentPageAPI
        let pictureNumberPerPage = viewModel?.pictureNumberPerPage

        try await viewModel?.getOtherPicturesPages(currentIndexPictureDisplayed: currentIndex)

        XCTAssertNotEqual(currentPageAPI, viewModel?.currentPageAPI)
        XCTAssertNotEqual(currentPageAPI, 9)
        XCTAssertNotEqual(pictureNumberPerPage, viewModel?.pictureNumberPerPage)
        XCTAssertNotEqual(pictureNumberPerPage, 20)
    }

    func test_GivenTheIndexisNotLargeEnoughToActivateThisMethod_ThenThePicturesDisplayDontMove() async throws {

        let currentIndex = 5
        let currentPageAPI = viewModel?.currentPageAPI
        let pictureNumberPerPage = viewModel?.pictureNumberPerPage

        try await viewModel?.getOtherPicturesPages(currentIndexPictureDisplayed: currentIndex)

        XCTAssertEqual(currentPageAPI, viewModel?.currentPageAPI)
        XCTAssertEqual(pictureNumberPerPage, viewModel?.pictureNumberPerPage)
    }

    
        //MARK: - test HomeViewModel/numberOfColumns
    func test_GivenThanWeAskAnNewNumberOfColumns_ThenTheNumberOfColumnsChanges() {
        let newNumberOfColumns = 3

        viewModel?.ChangeNumberOfColumns(newNumberOfColumns)

        XCTAssertEqual(newNumberOfColumns, viewModel?.numberOfColumns)
    }


        //MARK: - test HomeViewModel/resetSearchPicture
    func test_GivenResetCountersForANewResearch() {
        let currentPageAPI = 1
        let pictureNumberPerPage = 10
        viewModel?.currentPageAPI = 2
        viewModel?.pictureNumberPerPage = 20
        viewModel?.pictures = Picture.examples

        viewModel?.resetSearchPicture()

        XCTAssertEqual(viewModel?.pictures.count, 0)
        XCTAssertEqual(currentPageAPI, viewModel?.currentPageAPI)
        XCTAssertEqual(pictureNumberPerPage, viewModel?.pictureNumberPerPage)
    }
}
