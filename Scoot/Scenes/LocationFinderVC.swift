//
//  LocationFinderVC.swift
//  Scoot
//
//  Created by Luka Vujnovac on 26.07.2022..
//

import UIKit
import MapKit
import CoreLocation

class LocationFinderVC: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    private var searchBar = UISearchBar()
    private var searchResultsTable = UITableView()
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var searchResults = [MKLocalSearchCompletion]()
    
    var didSelectLocation: (() -> Void)?
    private var manager: CLLocationManager?
    
    private var currentLocationLon = CLLocationDegrees(0)
    private var currentLocationLat = CLLocationDegrees(0)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsTable.frame = view.bounds
        
        searchBar.frame = CGRect(x: 16, y: 20, width: UIScreen.main.bounds.width - 32, height: 40)
        view.bringSubviewToFront(searchBar)
    }
}

extension LocationFinderVC {
    private func configureTable() {
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
        self.dismiss(animated: true, completion: self.didSelectLocation)
        
        if indexPath.row == 0 {
            LocationManager.shared.locationLat = currentLocationLat
            LocationManager.shared.locationLon = currentLocationLon
        }else {
            let result = searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: result)
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let coordinate = response?.mapItems[0].placemark.coordinate else { return }
                let locationString = "\(self.searchResults[indexPath.row - 1].title) \(self.searchResults[indexPath.row - 1].subtitle)"
                UserDefaults.standard.setLocation(location: locationString)
                LocationManager.shared.locationLat = coordinate.latitude
                LocationManager.shared.locationLon = coordinate.longitude
            }
        }
    }
}

extension LocationFinderVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {return}
        currentLocationLon = first.coordinate.longitude
        currentLocationLat = first.coordinate.latitude
        
        let locationLonString = "\(first.coordinate.longitude)"
        let locationLatString = "\(first.coordinate.latitude)"
        
        LocationManager.shared.getAddressFromLatLon(pdblLatitude: locationLatString, withLongitude: locationLonString)
    }
}

