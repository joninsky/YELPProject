//
//  GraphQLNetworkControllerAvailable.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/12/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit


protocol GraphQLNetworkControllerAvailable {
    var graphQLNetworkController: GraphQLNetworkController? { get }
}


extension GraphQLNetworkControllerAvailable {
    var graphQLNetworkController: GraphQLNetworkController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.graphQLNetworkController
        
    }
}
