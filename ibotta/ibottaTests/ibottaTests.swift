//
//  ibottaTests.swift
//  ibottaTests
//
//  Created by Daniel Person on 6/11/23.
//

import XCTest
@testable import ibotta

final class ibottaTests: XCTestCase {
    
    let imageUrl = "someUrl"
    
    override func setUpWithError() throws {
        guard let image = UIImage(systemName: "star") else {
            throw NSError(domain: "setupErrorDomain", code: -1)
        }
        ApplicationState.addCachedImage(forItem: ImageItem(url: imageUrl, image: image))
    }

    override func tearDownWithError() throws {
        ApplicationState.clearCachedImages()
    }

    func testThatAnImageIsCached() {
        
        let image = ApplicationState.cachedImage(fromUrl: imageUrl)
        
        XCTAssert(image != nil, "Image was nil; setup failed")
    }
    
    func testThatACachedImageIsRemoved() {
        ApplicationState.clearCachedImages()
        
        let image = ApplicationState.cachedImage(fromUrl: imageUrl)
        
        XCTAssert(image == nil, "Image was not nil")
    }
}
