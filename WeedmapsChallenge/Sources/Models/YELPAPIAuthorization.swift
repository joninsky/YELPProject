//
//  YELPAPIAuthorization.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct YELPAPIAuthorization: Authorization {
    internal var clientID: String = "m9BzIaMLjFPHc3rSPT0z2A"
    
    internal var apiKey: String = "qco6Jeyqwo8-v8QRaCxWSiO5Fwr7JhWOSObUthK4ajdFVGuTvPHNjmi_b9A_UaOAmJzo2Vt6GlEmyxJwIOs2yWXr3FcPK0x3QBA-YpLFPq-w_UnIl9Q4bb0_SumwXHYx"
    
    public var authorizationHeader: [String : String] {
        return ["Authorization": "Bearer \(self.apiKey)"]
    }
    
    public init() {
        
    }
}
