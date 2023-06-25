    //
    //  APIUnsplashTests.swift
    //  APIUnsplashTests
    //
    //  Created by Greg Deveaux on 17/06/2023.
    //

import XCTest
@testable import SearchPic

final class APIUnsplashTests: XCTestCase {

    var urlSession: URLSession!
    var expectation: XCTestExpectation!
    var statusCode: Int!

    var searchWord = "plage"
    lazy var urlOfsearchWord: String = {
        return "https://api.unsplash.com/search/photos?page=1&lang=fr&query=\(searchWord)&client_id=zQzGRjojH3JNE-S9qLgcGmfzvZbp9NrT6ZlzqXKny6c"
    }()

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
        statusCode = 200
    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
        viewModel = nil
    }


        //MARK: - test endPoint

    func test_GivenTheGoodURLRequestOfUnsplashAPI_ThenTheGenerationOftheURLIsOk() async throws {

        let apiURLWished = URL(string: urlOfsearchWord)

        let urlEndpoint = viewModel?.createUrl(with: searchWord)

        XCTAssertEqual(urlEndpoint, apiURLWished)
    }


        //MARK: - AsyncTest for API Unsplash(Mock)

    func test_SearchPlageWithGoodMockData() async throws {
            // When
        baseQuery(data: MockResponseData.unsplashCorrectData, response: MockResponseData.responseOK)

            // Then
        do {
            try await viewModel?.searchPictures(with: searchWord)

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
            XCTAssertEqual(statusCode, 200, "Expected a 200 OK response.")

        } catch {
            XCTFail("🛑 There is an error in the test_SearchPlageWithGoodMockData: \(error)")
        }

    }

    func test_SearchPlage_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() async throws {
            // When
        baseQuery(data: MockResponseData.unsplashCorrectData, response: MockResponseData.responseFailed)

            // Then
        do {
            try await viewModel?.searchPictures(with: searchWord)
            XCTFail("🛑 There is an error in the test_SearchPlage_WhenINotRecoverAStatusCode500_ThenMyResponseFailed")
        } catch {
            XCTAssertEqual(error as? SearchPictureError, .invalidResponse)
            XCTAssertEqual(statusCode, 500, "Expected a 500 response failed.")
        }
    }

    func test_SearchPlage_WhenIRecoverABadData_ThenDecodeJsonDataFailed() async throws {
            // When
        baseQuery(data: MockResponseData.mockDataFailed, response: MockResponseData.responseOK)

            // Then
        do {
            try await viewModel?.searchPictures(with: searchWord)
            XCTFail("🛑 There is an error in the test_SearchPlage_WhenIRecoverABadData_ThenDecodeJsonDataFailed")
        } catch {
            XCTAssertEqual(error as? SearchPictureError, .invalidData)
            XCTAssertEqual(statusCode, 200, "Expected a 200 OK response.")
        }
    }

    func test_SearchPlage_WhenIRecoverABadUrl_ThenNotResponse() async throws {
            // When
        let badPage = -22
        viewModel?.currentPageAPI = badPage

        baseQuery(data: MockResponseData.unsplashCorrectData, response: MockResponseData.badUrl)

            // Then
        do {
            try await viewModel?.searchPictures(with: searchWord)
            XCTFail("🛑 There is an error in the test_SearchPlage_WhenIRecoverABadUrl_ThenNotResponse")
        } catch {
            XCTAssertEqual(error as? SearchPictureError, .invalidUrl)
            XCTAssertEqual(statusCode, 404, "Expected a 404, the requested resource doesn’t exist.")
        }
    }

    func test_() throws {

    }

    func testPerformanceExample() throws {
            // This is an example of a performance test case.
        self.measure {
                // Put the code you want to measure the time of here.
        }
    }


        //MARK: - Methode
    private func baseQuery(data: Data?, response: HTTPURLResponse) {

        let data = data

        MockURLProtocol.requestHandler = { request in
            let response = response
            self.statusCode = response.statusCode
            return (response, data)
        }
    }
}
