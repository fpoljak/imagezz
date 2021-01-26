//
//  ImagezzUITests.swift
//  ImagezzUITests
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import XCTest
import Swifter

class ImagezzUITests: XCTestCase {
    var server: HttpServer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        server.stop()
        try super.tearDownWithError()
    }

    func testExample() throws {
        server = HttpServer()
        server.stubRequestsForEndpoint("list")
        server.stubRequestsForImages()
        try server.start()
        
        let app = XCUIApplication()
        app.launchArguments += ["TESTING"]
        
        app.launch()

        let exists = NSPredicate(format: "exists == true")
        
        let cells = app.collectionViews.cells
        let firstCell = cells.firstMatch
        
        self.expectation(for: exists, evaluatedWith: firstCell, handler: nil)
        
        self.waitForExpectations(timeout: 3.0) { (error) in
            guard error == nil else {
                return
            }
            
            cells.element(boundBy: 0).tap()
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            server = HttpServer()
            server.stubRequestsForEndpoint("list")
            server.stubRequestsForImages()
            try server.start()
            
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension HttpServer {
    func stubRequestsForEndpoint(_ endpoint: String) {
        var filename = endpoint
        if filename.hasSuffix(".json") {
            filename = String(filename.dropLast(5))
        }
        
        self["/v2/" + endpoint] = { _ in
            guard let url = Bundle(for: ImagezzUITests.self).url(forResource: filename, withExtension: "json") else {
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            guard let data = try? Data(contentsOf: url) else {
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            
            return HttpResponse.ok(.data(data, contentType: "application/json"))
        }
    }
    
    func stubRequestsForImages() {
        self["/id/:path"] = { _ in
            guard let url = Bundle(for: ImagezzUITests.self).url(forResource: "photo.jpg", withExtension: "json") else {
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            guard let data = try? Data(contentsOf: url) else {
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            
            return HttpResponse.ok(.data(data, contentType: "image/jpeg"))
        }
    }
}
