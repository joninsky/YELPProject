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
    private var paginationDataTask: URLSessionDataTask?
    
    private var paginationCount = 0
    
    private let emptyDataView = EmptyDataView(frame: .zero)
    
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
    
    //MARK: Function
    private func condition(inputString string: String) -> String? {
        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        guard trimmed.isEmpty == false else {
            self.searchResults.removeAll()
            self.collectionView.reloadData()
            return nil
        }
        return trimmed
    }
    
    private func processSearchResults(_ results: [String: Any], forQuery query: BusinessSearchRequest) throws {
        //Simply replace the data because we has fresh search results.
        let businesses = try query.parseResults(results)
        self.searchResults.removeAll()
        self.searchResults = businesses
        self.collectionView.reloadData()
    }
    
    private func processPaginationResults(_ results: [String: Any], forQuery query: BusinessSearchRequest) throws {
        //We need to add new results to the datasource. So get those results
        let businesses = try query.parseResults(results)
        //Append them.
        self.searchResults.append(contentsOf: businesses)
        //We need to tell the collection view where it needs to lad new cells. To do this we need to get the indexpaths that map to the new data.
        var pathes = [IndexPath]()
        //Iterate through the results and get the index.
        for (index, _) in businesses.enumerated() {
            //Always secion 0. Add the index of the new 15 results to the pagination count. This will result in an approrpiate index.
            let appropriateIndex = index + self.paginationCount
            //Make the path and add it to the array.
            let path = IndexPath(row: appropriateIndex, section: 0)
            pathes.append(path)
        }
        //Tell the collection view to insert our new paths.
        self.collectionView.insertItems(at: pathes)
    }

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
    ///:nodoc:
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let trimmed = self.condition(inputString: searchBar.text ?? "") else {
            return
        }
        //Only cache search if the user presses "Search" on the Keyboard. This fixes the bug of recording single letters and just records an intentional search.
        SearchCacher().cacheSearch(trimmed)
        searchBar.resignFirstResponder()
    }
    
    ///:nodoc:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        
        // IMPLEMENT: Be sure to consider things like network errors
        // and possible rate limiting from the Yelp API. If the user types
        // very quickly, how will you prevent unnecessary requests from firing
        // off? Be sure to leverage the searchDataTask and use it wisely!
        
        
        //Condition the string
        guard let trimmed = self.condition(inputString: searchText) else {
            return
        }
        
        //Cancel any pending requests
        self.searchDataTask?.cancel()
        //Kill any pagination task for a new search.
        self.paginationDataTask?.cancel()
        
        //Set pagination to 0 because we have a new search.
        self.paginationCount = 0
        
        //Get the location
        guard let location = self.locationController?.location else {
            self.alert(title: "Location Error", message: "We could not retreive your location. It is required to search.")
            return
        }
        
        //Make the query
        let query = BusinessSearchRequest(searchTerm: trimmed, location: location.coordinate)
        
        do{
            //Fire off the query and assign to the search data task.
            self.searchDataTask = try self.graphQLNetworkController?.makeGraphQLRequest(query, completion: { (data) in
                DispatchQueue.main.async {
                    do{
                        try self.processSearchResults(data, forQuery: query)
                    }catch{
                        self.alert(forError: error)
                    }
                }
            })
        }catch{
            self.alert(forError: error)
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
        switch self.searchResults.count {
        case 0:
            self.emptyDataView.state = .noData(description: "Nothing was found.")
        default:
            self.emptyDataView.state = .hasData
        }
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
        return UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            //We hit the bottom. We don't want to fire off new request concurrently.
            guard self.paginationDataTask == nil else {
                return
            }
        
            //Get The location and text.
            guard let location = self.locationController?.location, let text = self.condition(inputString: self.searchBar.text ?? "") else {
                return
            }
            
            
            //Increment pagination by 15 which is our results limit.
            self.paginationCount += 15
            
            
            //Make the query
            let query = BusinessSearchRequest(searchTerm: text, location: location.coordinate, offset: self.paginationCount)
            
            do{
                //Fire off the query and assign it to the pagination data task.
                self.paginationDataTask = try self.graphQLNetworkController?.makeGraphQLRequest(query, completion: { (data) in
                    DispatchQueue.main.async {
                        do{
                            //Parse the results
                            try self.processPaginationResults(data, forQuery: query)
                            //Set task to nill so we can load another 15.
                            self.paginationDataTask = nil
                        }catch{
                            self.alert(forError: error)
                        }

                    }
                })
            }catch{
                self.alert(forError: error)
            }
        }
    }
}

extension HomeViewController: UIKitCodePreparable {
    func prepare() {
        //Set up search bar
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.searchBar.backgroundColor = UIColor.white
        self.searchBar.delegate = self
        self.searchBar.accessibilityLabel = "Home Search Bar"
        
        //Set up the collection view status label
        self.emptyDataView.state = EmptyDataViewState.noData(description: "Search the YELP API for businesses near you.")
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.backgroundView = self.emptyDataView
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
