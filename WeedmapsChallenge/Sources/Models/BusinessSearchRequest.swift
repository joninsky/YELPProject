//
//  BusinessSearchRequest.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import CoreLocation


struct BusinessSearchRequest: GraphQLRequest {
    typealias Result = Business
    
    var graphQLLiteral: String = """
    query SearchTermByLocation($term: String!, $latitude: Float!, $longitude: Float!, $offset: Int!) {
      search(term: $term, latitude: $latitude, longitude: $longitude, limit: 15, offset: $offset) {
        business {
          name
          url
          photos
        }
      }
    }
    """
    
    var variables: [String : Any]
    
    init(searchTerm: String, location: CLLocationCoordinate2D, offset: Int = 0) {
        let variables: [String: Any] = ["term": searchTerm, "latitude": location.latitude, "longitude": location.longitude, "offset": offset]
        self.variables = variables
    }
    
    func parseResults(_ data: [String: Any]) throws -> [Result] {
        var results = [Result]()
        
        if let search = data["search"] as? [String: Any] {
            if let businesses = search["business"] as? [[String: Any]] {
                for item in businesses {
                    let data = try! JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                    let business = try! JSONDecoder().decode(Business.self, from: data)
                    results.append(business)
                }
            }
        }
        
        return results
        
    }
    
    
}
