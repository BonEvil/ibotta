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
    
    var data: Data?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatOfferDataJsonFileExists() {
        do {
            let data = try Bundle.dataFromJsonFile("Offers")
            self.data = data
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testThatTheOffersServiceUsesTheTestData() {
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
}
