//
//  YELPAPIDefinition.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation




struct YELPAPIDefinition: APIDefinition {
    internal var authroization: Authorization = YELPAPIAuthorization()
    
    internal var rootURLString: String = "https://api.yelp.com/v3/graphql"
    
    public init() {
        
    }
    
    internal func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.rootURLString) else {
            throw APIDefinitionError.couldNotConstructRequest
        }
        var request = URLRequest(url: url)
        let authHeader = self.authroization.authorizationHeader
        guard let key = authHeader.first?.key, let value = authHeader.first?.value else {
            throw APIDefinitionError.couldNotConstructAuthorization
        }
        request.addValue(value, forHTTPHeaderField: key)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
    }
    
}
