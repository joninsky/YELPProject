//
//  EmptyDataViewState.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit



public enum EmptyDataViewState {
    case noData(description: String)
    case noDataAttributed(description: NSAttributedString)
    case hasData
}
