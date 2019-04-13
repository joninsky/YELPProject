//
//  GraphQLRequest.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


protocol GraphQLRequest {
    associatedtype Result: Decodable, Encodable
    var graphQLLiteral: String { get }
    var variables: [String: Any] { get }
    func queryDictionary() throws -> [String: Any]
    func variablesString() throws -> String
    func queryData() throws -> Data
    func parseResults(_ data: [String: Any]) throws -> [Result]
}


extension GraphQLRequest {
    func queryDictionary() throws -> [String: Any] {
        let variablesString = try self.variablesString()
        return ["query": "\(self.graphQLLiteral)", "variables": variablesString]
    }
    
    
    func variablesString() throws -> String {
        let variablesData = try JSONSerialization.data(withJSONObject: self.variables, options: .prettyPrinted)
        
        guard let variablesString = String(data: variablesData, encoding: .utf8) else {
            throw GraphQLRequestError.couldNotConvertToString
        }
        
        return variablesString
    }
    
    func queryData() throws -> Data {
        let queryDictionary = try self.queryDictionary()
        return try JSONSerialization.data(withJSONObject: queryDictionary, options: .prettyPrinted)
    }
    

}
