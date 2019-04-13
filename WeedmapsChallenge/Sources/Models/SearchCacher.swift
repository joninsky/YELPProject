//
//  SearchCacher.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct SearchCacher {
    //MARK: Properties
    internal var defaults: UserDefaults
    internal var searchesKey = "searches"
    
    //MARK: Init
    public init(_ defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    //MARK: Functions
    func cacheSearch(_ search: String) {
        var allSearches = self.retreiveAllSearches()
        if allSearches.count == 15 {
            self.purgeSearches()
        }
        guard allSearches.contains(search) == false else {
            return
        }
        allSearches.insert(search, at: 0)
        self.defaults.set(allSearches, forKey: self.searchesKey)
    }
    
    func retreiveAllSearches() -> [String] {
        guard let object = self.defaults.object(forKey: self.searchesKey) else {
            return []
        }
        guard let array = object as? [String] else {
            return []
        }
        return array
    }
    
    func purgeSearches() {
        self.defaults.removeObject(forKey: self.searchesKey)
    }
}
