//
//  OffersService.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import BuckarooBanzai

struct OffersService: Service {
    var requestMethod: HTTPRequestMethod = .GET
    var acceptType: HTTPAcceptType = .JSON
    var timeout: TimeInterval = 10
    var requestURL: String = "https://example.com/offers"
    var contentType: HTTPContentType?
    var requestBody: Data?
    var parameters: [AnyHashable : Any]?
    var additionalHeaders: [AnyHashable : Any]?
    var requestSerializer: RequestSerializer?
    var sessionDelegate: URLSessionTaskDelegate?
    var testResponse: HTTPResponse?
    
    init() {
        /// Using the `testResponse` for local data retrieval
        do {
            let jsonData = try Bundle.dataFromJsonFile("Offers")
            testResponse = HTTPResponse(statusCode: 200, headers: ["Content-Type": "application/json"], body: jsonData)
        } catch {
            print("FILE ERROR: \(error)")
        }
    }
}
