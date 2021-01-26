//
//  ImagezzTests.swift
//  ImagezzTests
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import XCTest
@testable import Imagezz
import OHHTTPStubs

class ImagezzTests: XCTestCase {

    override func setUpWithError() throws {
        // enable mocking api calls
        HTTPStubs.setEnabled(true)
        let host = URL(string: ApiService.baseUrl)!.host!
        stub(condition: isHost(host)) { request in
            // if photo:
            if let url = request.url?.absoluteString, url.hasPrefix("https://picsum.photos/id/") {
                if let path = OHPathForFile("photo.jpg", type(of: self)) {
                    return fixture(filePath: path, headers: ["Content-Type": "image/jpeg"])
                }
            }
            // loook for .json file in mocks folder
            if let endpoint = request.url?.lastPathComponent {
                var filename = endpoint
                if !filename.hasSuffix(".json") {
                    filename += ".json"
                }
                if let path = OHPathForFile(filename, type(of: self)) {
                    return fixture(filePath: path, headers: ["Content-Type": "application/json"])
                }
            }
            let data = "{}".data(using: String.Encoding.utf8)
            return HTTPStubsResponse(data: data!, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    func testList() throws {
        let vc = MainViewController()
        vc.loadViewIfNeeded()
        
        XCTAssertTrue(vc.viewModel.isLoading)
        
        let expectation = self.expectation(description: #function)
        // wait for mock data to load
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(vc.viewModel.isLoading)
        XCTAssertEqual(vc.viewModel.currentPage, 1)
        XCTAssertFalse(vc.viewModel.reachedEnd)
        XCTAssertEqual(vc.viewModel.items.value.count, 25)
    }
    
    func testDetails() throws {
        let item = ImageItem(id: "1", author: "John Smith", width: 20, height: 20, url: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!, downloadUrl: URL(string: "https://picsum.photos/id/0/5616/3744")!)
        let vc = ImageDetailViewController()
        vc.loadViewIfNeeded()
        vc.viewModel.imageItem = item
        
        XCTAssertEqual(vc.titleLabel.text, "Author: John Smith")
        
        let expectation = self.expectation(description: #function)
        // wait for mock image to load
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(vc.imageView.image)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
