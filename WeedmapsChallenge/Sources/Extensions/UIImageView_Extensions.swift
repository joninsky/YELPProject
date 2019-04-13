//
//  UIImageView_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String, cache: NSCache<AnyObject, AnyObject>? = imageCache) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        if let cachedImage = cache?.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return nil
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (p_data, p_response, p_error) in
            guard let data = p_data else {
                return
            }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data) else {
                    return
                }
                cache?.setObject(imageToCache, forKey: url as AnyObject)
                self.image = imageToCache
            }
        }
        task.resume()
        return task
    }
}
