//
//  RecentSearchesViewController.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit


class RecentSearchesViewController: UIViewController {
    //MARK: Properties
    internal let tableView = UITableView(frame: .zero)
    
    internal var searches = [String]()
    
    public weak var delegate: RecentSearchesViewControllerDelegate?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
    }
    
    //MARK: Overrides
    
    //MARK: Notifications
    
    //MARK: Actions
    
    //MARK: Custom functions
    
    //MARK: De - Init
    deinit {
        print("De - Initalized RecentSearchesViewController")
    }
}

extension RecentSearchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SEARCHCELL") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = self.searches[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchSeelcted(self.searches[indexPath.row])
    }
}

extension RecentSearchesViewController: UIKitCodePreparable {
    func prepare(){
        
        self.searches = SearchCacher().retreiveAllSearches()
        
        //Set up table view
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SEARCHCELL")
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        //Set up self
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.constrain()
        
    }
    func constrain() {
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
    }
}
