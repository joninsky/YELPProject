//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeedmapsChallenge


class YelpAPIClientTests: XCTestCase {

    var mockLocation: CLLocationCoordinate2D!
    var request: BusinessSearchRequest!
    let apiDefinition = YELPAPIDefinition()
    var networker: GraphQLNetworkController!
    
    override func setUp() {
        self.mockLocation = CLLocationCoordinate2DMake(47.7070331, -122.1897554)
        self.request = BusinessSearchRequest(searchTerm: "Sushi", location: mockLocation)
        self.networker = GraphQLNetworkController(apiDefinition: apiDefinition)
    }

    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBusinessModelDecodedFromJsonYieldsExpectedResult() {
        let bundle = Bundle(for: type(of: self))
        let jsonFile = bundle.path(forResource: "MockResults", ofType: "json")
        let jsonURL = URL(fileURLWithPath: jsonFile!)
        let data = try! Data(contentsOf: jsonURL)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        let businesses = try! self.request.parseResults(dictionary)
        XCTAssertTrue(businesses.count == 15)
        
    }
    
    func testYelpAPIRequestYieldsExpectedResult() {
        let expectation = XCTestExpectation(description: "request")
        let _ = try! networker.makeGraphQLRequest(request) { (p_dictionary) in
            XCTAssertTrue(!p_dictionary.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
