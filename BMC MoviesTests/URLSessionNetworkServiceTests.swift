//
//  URLSessionNetworkServiceTests.swift
//  BMC MoviesTests
//
//  Created by Basith P on 19/09/25.
//

@testable import BMC_Movies
import Combine
import XCTest

private struct DummyEndpoint: APIEndpoint {
  var baseURL: URL { URL(string: "https://unit.test")! }
  var path: String
  var method: String = "GET"
  var headers: [String : String]? = nil
  var queryItems: [URLQueryItem]? = nil
}

@MainActor final class URLSessionNetworkServiceTests: XCTestCase {
  private var cancellables: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    cancellables = []
    MockURLProtocol.requestHandler = nil
  }

  override func tearDown() {
    cancellables = nil
    super.tearDown()
  }

  private func makeMockedSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
  }

  @MainActor func test_NetworkService_request_success_decodesMovieResponse() {
    let session = makeMockedSession()
    let service = URLSessionNetworkService(session: session)
    let endpoint = DummyEndpoint(path: "movies")

    let json = """
        {
          "results": [
            {
              "adult": false, "id": 1, "title": "Test Movie", "original_title": "Test Movie",
              "overview": "An overview.", "popularity": 1.0, "release_date": "2023-01-01",
              "video": false, "vote_average": 1.0, "vote_count": 1,
              "original_language": "en", "genre_ids": [1],
              "backdrop_path": "/path.jpg", "poster_path": "/path.jpg"
            }
          ]
        }
        """.data(using: .utf8)!

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
      return (response, json)
    }

    let expectation = XCTestExpectation(description: "Successfully decodes MovieResponse")

    service.request(endpoint: endpoint)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          XCTFail("Request failed with unexpected error: \(error)")
        }
      }, receiveValue: { (response: MovieResponse) in
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.id, 1)
        XCTAssertEqual(response.results.first?.title, "Test Movie")
        expectation.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)
  }

  func test_request_httpError_mapsToNetworkError() {
    let session = makeMockedSession()
    let service = URLSessionNetworkService(session: session)
    let endpoint = DummyEndpoint(path: "error")

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
      return (response, Data())
    }

    let expectation = XCTestExpectation(description: "Request fails with an HTTP error")

    service.request(endpoint: endpoint)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          XCTFail("Request should have failed, but it finished successfully.")
        case .failure(let error):
          guard case .httpError(let statusCode) = error else {
            XCTFail("Expected .httpError, but got \(error)")
            return
          }
          XCTAssertEqual(statusCode, 404)
          expectation.fulfill()
        }
      }, receiveValue: { (_: MovieResponse) in
        XCTFail("Should not receive a value on failure.")
      })
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)
  }

  func test_request_decodingFailure_mapsToDecodingFailedError() {
    let session = makeMockedSession()
    let service = URLSessionNetworkService(session: session)
    let endpoint = DummyEndpoint(path: "malformed")
    let malformedJSON = "{ \"results\": [{\"id\": \"not_an_int\"}] }".data(using: .utf8)!

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
      return (response, malformedJSON)
    }

    let expectation = XCTestExpectation(description: "Request fails with a decoding error")

    service.request(endpoint: endpoint)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          guard case .decodingFailed = error else {
            XCTFail("Expected .decodingFailed, but got \(error)")
            return
          }
          expectation.fulfill()
        } else {
          XCTFail("Request should have failed.")
        }
      }, receiveValue: { (_: MovieResponse) in
        XCTFail("Should not receive a value on decoding failure.")
      })
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)
  }

  func test_request_networkFailure_mapsToRequestFailedError() {
    let session = makeMockedSession()
    let service = URLSessionNetworkService(session: session)
    let endpoint = DummyEndpoint(path: "network-failure")
    let networkError = URLError(.notConnectedToInternet)

    MockURLProtocol.requestHandler = { _ in
      throw networkError
    }

    let expectation = XCTestExpectation(description: "Request fails with a network error")

    service.request(endpoint: endpoint)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          guard case .requestFailed(let underlyingError as URLError) = error else {
            XCTFail("Expected .requestFailed with URLError, but got \(error)")
            return
          }
          XCTAssertEqual(underlyingError.code, .notConnectedToInternet)
          expectation.fulfill()
        } else {
          XCTFail("Request should have failed.")
        }
      }, receiveValue: { (_: MovieResponse) in
        XCTFail("Should not receive a value on network failure.")
      })
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 3.0)
  }
}
