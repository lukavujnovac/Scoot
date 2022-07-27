//
//  LocationFinderVC.swift
//  Scoot
//
//  Created by Luka Vujnovac on 26.07.2022..
//

import UIKit
import MapKit

class LocationFinderVC: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    var searchBar = UISearchBar()
    var searchResultsTable = UITableView()
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var searchResults = [MKLocalSearchCompletion]()
    
    var didSelectLocation: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchBar.delegate = self
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        
        view.backgroundColor = .red
        
        hideKeyboardWhenTappedAround()
        
        view.addSubview(searchBar)
        view.addSubview(searchResultsTable)
        configureTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsTable.frame = view.bounds
        
        searchBar.frame = CGRect(x: 16, y: 20, width: UIScreen.main.bounds.width - 32, height: 40)
        view.bringSubviewToFront(searchBar)
    }
    
    func configureTable() {
        searchResultsTable.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationCell.identifier)
        searchResultsTable.register(UINib(nibName: "CurrentLocationCell", bundle: nil), forCellReuseIdentifier: CurrentLocationCell.identifier)
        searchResultsTable.contentInset.top = 60
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        
        searchResultsTable.reloadData()
    }
}

extension LocationFinderVC: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let searchResult = searchResults[indexPath.row - 1]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentLocationCell.identifier, for: indexPath) as? CurrentLocationCell else {fatalError()}
            cell.configure()
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {fatalError()}
            
            cell.configure(with: "\(searchResults[indexPath.row - 1].title) \(searchResults[indexPath.row - 1].subtitle)")
            return cell
        }
    }
}

extension LocationFinderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: didSelectLocation)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            //            guard let coordinate = response?.mapItems[0].placemark.coordinate else { return }            
            //            guard let name = response?.mapItems[0].name else { return }
            let locationString = "\(self.searchResults[0].title) \(self.searchResults[0].subtitle)"
            UserDefaults.standard.setLocation(location: locationString)
            //            let lat = coordinate.latitude
            //            let lon = coordinate.longitude
        }
    }
}

