//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import WebKit


class HomeDetailViewController: UIViewController {

    // MARK: Properties
    let webView: WKWebView = WKWebView(frame: .zero)
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
    }
    
    //MARK: Actions

    
    // MARK: Control
    
    func configure(with business: Business) {
        guard let url = URL(string: business.url) else {
            return
        }
        self.webView.load(URLRequest(url: url))
    }
}

extension HomeDetailViewController: UIKitCodePreparable {
    func prepare() {
        //Set up web view
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Set up navigation
        self.navigationItem.title = "Business Page"
        self.view.addSubview(self.webView)
        self.constrain()
        
    }
    
    func constrain() {
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    }
    
    
}
