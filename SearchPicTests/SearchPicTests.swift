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

    func test_GivenTheGoodURLRequestOfUnsplashAPI_ThenTheGenerationOftheURLIsOk() throws {

        let urlEndpoint = viewModel?.createUrl(with: "plage")

        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_SearchPlageWithGoodMockData() throws {
            // When
        baseQuery(data: MockResponseData.unsplashCorrectData, response: MockResponseData.responseOK)

            // Then
        Task {
            try await viewModel?.searchPictures(with: "plage")

            let picture = viewModel?.pictures[1]

            XCTAssertNotNil(viewModel?.pictures)
            XCTAssertEqual(viewModel?.pictures.count, 10)

            XCTAssertEqual(picture?.id, "KMn4VEeEPR8")
            XCTAssertEqual(picture?.description, "The last night of a two week stay on the North Shore of Oahu, Hawaii.")
            XCTAssertEqual(picture?.user.name, "Sean Oulashin")

            XCTAssertEqual(picture?.urls.download, "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3")
            XCTAssertEqual(picture?.urls.largeSize, "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=1080")
            XCTAssertEqual(picture?.urls.mediumSize, "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=400")
            XCTAssertEqual(picture?.urls.smallSize, "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjI4NDV8MHwxfHNlYXJjaHwyfHxwbGFnZXxmcnwwfHx8fDE2ODcxMjM3MjR8MA&ixlib=rb-4.0.3&q=80&w=200")
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

//    func test_SearchPlage_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() throws {
//            // When
//        baseQuery(data: MockResponseData.unsplashCorrectData, response: MockResponseData.responseFailed)
//
//            // Then
//        Task {
//            try await viewModel?.searchPictures(with: "plage")
//
//            XCTAssertEqual(Error.localizedDescription, "")
//
//            self.expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//    }


        //MARK: - Methode
    private func baseQuery(data: Data?, response: HTTPURLResponse) {
        expectation = expectation(description: "Expectation")

        let data = data

        MockURLProtocol.requestHandler = { request in
            let response = response
            return (response, data)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
