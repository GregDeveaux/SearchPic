//
//  SearchPicTests.swift
//  SearchPicTests
//
//  Created by Greg Deveaux on 17/06/2023.
//

import XCTest
@testable import SearchPic

final class SearchPicTests: XCTestCase {

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    let apiURL = URL(string: "https://api.unsplash.com/search/photos?page=1&lang=fr&query=plage&client_id=zQzGRjojH3JNE-S9qLgcGmfzvZbp9NrT6ZlzqXKny6c")
    var viewModel: HomeViewModel?

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)

            // Setup a configuration to use our mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

            // Create the URLSession configurated
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func test_GivenTheGoodURLRequestOfGoogleBookIdAPI_ThenTheGenerationOftheURLIsOk() throws {

        let urlEndpoint = viewModel?.createUrl(with: "plage")

        XCTAssertEqual(urlEndpoint, apiURL)
    }


    func test_SearchPlageWithGoodMockData() throws {
            // Given
        expectation = expectation(description: "Expectation")

            //When
        let data = MockResponseData.unsplashCorrectData

        MockURLProtocol.requestHandler = { request in
            let response = MockResponseData.responseOK
            return (response, data)
        }
            //Then
        Task {
            try await viewModel?.searchPictures(with: "plage")
            self.expectation.fulfill()
        }
        XCTAssertNotNil(viewModel?.pictures)
        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
