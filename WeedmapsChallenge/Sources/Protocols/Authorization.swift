//
//  Authorization.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


protocol Authorization {
    var clientID: String { get }
    var apiKey: String { get }
    var authorizationHeader: [String: String] { get }
}
