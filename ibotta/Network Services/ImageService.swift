//
//  ImageService.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import BuckarooBanzai

struct ImageService: Service {
    var requestMethod: HTTPRequestMethod = .GET
    var acceptType: HTTPAcceptType = .ANY
    var timeout: TimeInterval = 10
    var requestURL: String
    var contentType: HTTPContentType?
    var requestBody: Data?
    var parameters: [AnyHashable : Any]?
    var additionalHeaders: [AnyHashable : Any]?
    var requestSerializer: RequestSerializer?
    var sessionDelegate: URLSessionTaskDelegate?
    var testResponse: HTTPResponse?
    
    init(withImageUrl url: String) {
        self.requestURL = url
    }
}
