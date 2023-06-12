//
//  NetworkTests.swift
//  ibottaTests
//
//  Created by Daniel Person on 6/11/23.
//

import XCTest
@testable import ibotta
@testable import BuckarooBanzai

final class NetworkTests: XCTestCase {
    
    var data: Data? {
        didSet {
            self.httpResponse = HTTPResponse(statusCode: 200, headers: [:], body: self.data)
        }
    }
    var httpResponse: HTTPResponse?

    override func setUpWithError() throws {
        do {
            let data = try Bundle.dataFromJsonFile("Offers")
            self.data = data
        } catch {
            throw error
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatTheOffersServiceUsesTheTestData() throws {
        let service = OffersService()
        Task {
            do {
                let response = try await BuckarooBanzai.shared.start(service: service)
                let data = response.body
                XCTAssert(data == self.data, "Data does not match")
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testThatTheOfferModelDecodesFromTestData() throws {
        guard let response = self.httpResponse else {
            throw NSError(domain: "networktestErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "self.httpResponse not set"])
        }
        do {
            let _: [Offer] = try response.decodeBodyData(convertFromSnakeCase: true)
        } catch {
            XCTFail("\(error)")
        }
    }
}
