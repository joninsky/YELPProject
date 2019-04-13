//
//  APIDefinition.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

protocol APIDefinition {
    var authroization: Authorization { get }
    var rootURLString: String { get }
    func asURLRequest() throws -> URLRequest
}
