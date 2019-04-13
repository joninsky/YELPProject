//
//  GraphQLRequestController.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

struct GraphQLNetworkController {
    //MARK: Properties
    private let definition: APIDefinition!
    
    //MARK: Init
    public init(apiDefinition definition: APIDefinition) {
        self.definition = definition
    }
    
    //MARK: Functions
    
    public func makeGraphQLRequest<T: GraphQLRequest>(_ request: T, completion: @escaping(_ data: [String: Any]) -> Void) throws -> URLSessionDataTask {
        
        var urlRequest = try! self.definition.asURLRequest()
        
        //https://github.com/Yelp/yelp-fusion/issues/251
        urlRequest.addValue("en_US", forHTTPHeaderField: "Accept-Language")
        
        urlRequest.httpBody = try! request.queryData()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (p_data, p_response, p_error) in

            guard let data = p_data else {
                completion([:])
                return
            }
            guard let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                completion([:])
                return
            }
            
            guard let parsedData = json["data"] as?[String: Any] else {
                completion([:])
                return
            }
            
            completion(parsedData)

        }

        task.resume()
        
        return task
    }
    
}
