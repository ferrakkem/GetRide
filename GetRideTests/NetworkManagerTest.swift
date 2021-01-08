//
//  NetworkManagerTest.swift
//  GetRideTests
//
//  Created by Ferrakkem Bhuiyan on 2021-01-06.
//

import XCTest
@testable import GetRide

class NetworkManagerTest: XCTestCase {
    private var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        self.networkManager = NetworkManager()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_API_BaseURLString_isCorrect() {
        let baseURLString = "\(EndPoint.tripUrl)\(EndPoint.RequestType.get_trip)"
        let expectedBaseURLString = "https://5vb5vug3qg.execute-api.us-east-1.amazonaws.com/get_trip"
        XCTAssertEqual(baseURLString, expectedBaseURLString, "Base URL does not match expected base URL. Expected base URLs to match.")
    }
    
    // Asynchronous test: success fast, failure slow
    func test_Status_Code_200() {
        let sut: URLSession!
        sut = URLSession(configuration: .default)
      // given
        let url = URL(string: "\(EndPoint.tripUrl)\(EndPoint.RequestType.get_trip)")
      // 1
      let promise = expectation(description: "Status code: 200")

      // when
      let dataTask = sut.dataTask(with: url!) { data, response, error in
        // then
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            // 2
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      // 3
      wait(for: [promise], timeout: 5)
    }
    
    func test_iS_parseing_succesful() {
        let _ : ((Result<RealmDataModel, Error>) -> Void) = { result in
            switch result {
            case .failure(_):
                XCTAssert(false, "Failed")
            case .success( _):
                XCTAssert(true, "Succes")
            }
        }
    }
    
}
