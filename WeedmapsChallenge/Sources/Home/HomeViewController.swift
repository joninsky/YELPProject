//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, GraphQLNetworkControllerAvailable, LocationControllerAvailable{

    // MARK: Properties
    
    private let flowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    private var searchBar = UISearchBar(frame: .zero)
    private var searchResults = [Business]()
    private var searchDataTask: URLSessionDataTask?
    
    private var paginationCount = 0
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepare()
    }
    
    //MARK: Actions
    @objc func recentSearchesSelected(_ sender: Any) {
        let recentSearchVC = RecentSearchesViewController()
        recentSearchVC.delegate = self
        self.navigationController?.pushViewController(recentSearchVC, animated: true)
    }
    
    //MARK: Notifications
    @objc func locationServiceStarted(_ sender: Any) {
        self.locationController?.startLocationServices()
    }
    
    //MARK: Actions

}

//MARK: RecentSearchesViewControllerDelegate

extension HomeViewController: RecentSearchesViewControllerDelegate {
    func searchSeelcted(_ key: String) {
        self.searchBar.text = key
        self.searchBar(self.searchBar, textDidChange: key)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let trimmed = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        guard trimmed.isEmpty == false else {
            self.searchResults.removeAll()
            self.collectionView.reloadData()
            return
        }
        
        // IMPLEMENT: Be sure to consider things like network errors
        // and possible rate limiting from the Yelp API. If the user types
        // very quickly, how will you prevent unnecessary requests from firing
        // off? Be sure to leverage the searchDataTask and use it wisely!

        self.searchDataTask?.cancel()
        
        self.paginationCount = 0
        
        guard let location = self.locationController?.location else {
            return
        }
        
        let query = BusinessSearchRequest(searchTerm: trimmed, location: location.coordinate)
        
        do{
            self.searchDataTask = try self.graphQLNetworkController?.makeGraphQLRequest(query, completion: { (data) in
                DispatchQueue.main.async {
                    let businesses = try! query.parseResults(data)
                    self.searchResults.removeAll()
                    self.searchResults = businesses
                    self.collectionView.reloadData()
                    //Only cache search if request is complete.
                    SearchCacher().cacheSearch(trimmed)
                }
            })
        }catch{
            print(error)
        }
    }
}


// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Leave this app?", message: "You can view the business page either in this app (No) or in whatever app intercepts this URL (Yes)", preferredStyle: .actionSheet)
        let no = UIAlertAction(title: "No", style: .default) { (action) in
            let detailVC = HomeDetailViewController()
            detailVC.configure(with: self.searchResults[indexPath.row])
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let urlString = self.searchResults[indexPath.row].url
            guard let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.popoverPresentationController?.sourceView = collectionView.cellForItem(at: indexPath)
        alert.popoverPresentationController?.sourceRect = collectionView.cellForItem(at: indexPath)?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        alert.addAction(no)
        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        // IMPLEMENT:
        // 1a) Present the user with a UIAlertController (action sheet style) with options
        // to either display the Business's Yelp page in a WKWebView OR bump the user out to
        // Safari. Both options should display the Business's Yelp page details
    }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // IMPLEMENT:
        print(searchResults.count)
        return self.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BUSINESSCELL", for: indexPath) as? BusinessCell else {
            return UICollectionViewCell()
        }
        
        let business = self.searchResults[indexPath.row]
        
        cell.marryBusiness(business)
        
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIScreen.main.traitCollection.userInterfaceIdiom {
        case .pad:
            return CGSize(width: 150, height: 200)
        default:
            let availableWidth = collectionView.bounds.width - 8
            
            let half = availableWidth / 2
            
            let size = CGSize(width: half - 10, height: 150)
            
            return size
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            self.paginationCount += 15
            
            print(paginationCount)
            
            guard let location = self.locationController?.location, let text = self.searchBar.text else {
                return
            }
            
            let query = BusinessSearchRequest(searchTerm: text, location: location.coordinate, offset: self.paginationCount)
            
            do{
                let _ = try self.graphQLNetworkController?.makeGraphQLRequest(query, completion: { (data) in
                    DispatchQueue.main.async {
                        let businesses = try! query.parseResults(data)
                        self.searchResults.append(contentsOf: businesses)
                        var pathes = [IndexPath]()
                        for (index, _) in businesses.enumerated() {
                            let path = IndexPath(row: index + self.paginationCount, section: 0)
                            pathes.append(path)
                        }
                        self.collectionView.insertItems(at: pathes)
                    }
                })
            }catch{
                print(error)
            }
        }
    }
}

extension HomeViewController: UIKitCodePreparable {
    func prepare() {
        //Set up search bar
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.searchBar.delegate = self
        self.searchBar.accessibilityLabel = "Home Search Bar"
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        self.collectionView.backgroundColor = UIColor.lightGray
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "BusinessCell", bundle: Bundle.main)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "BUSINESSCELL")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.keyboardDismissMode = .interactive
        self.collectionView.accessibilityLabel = "Home Collection View"
        
        //Set up navigation item
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(self.recentSearchesSelected(_:)))
        self.navigationItem.rightBarButtonItem = button
        self.navigationItem.title = "Business Search"
        
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.collectionView)
        self.constrain()
        
        self.locationController?.requestAuthorization()
        
        //Set up notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationServiceStarted(_:)), name: LocationServicesChangedNotification, object: nil)
    }
    
    func constrain() {
        
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        self.searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        
        self.collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
    }
}
