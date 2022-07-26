//
//  LocationListVC.swift
//  Scoot
//
//  Created by Profico on 22.07.2022..
//

import UIKit
import FloatingPanel

class LocationListVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationCell.identifier)
        table.register(UINib(nibName: "CurrentLocationCell", bundle: nil), forCellReuseIdentifier: CurrentLocationCell.identifier)
//        table.contentInset.top = 100
        
        return table
    }()
    
    private let field: UITextField = {
        let f = UITextField()
        f.placeholder = "search location"
        f.layer.cornerRadius = 9
        f.backgroundColor = .gray
        f.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        f.leftViewMode = .always
        
        
        return f 
    }()
    
    var locations = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .systemBackground
        
//        let panel = FloatingPanelController()
//        panel.set(contentViewController: LocationResultsVC())
//        panel.addPanel(toParent: self)
        tableView.backgroundColor = .secondarySystemBackground
        
        field.delegate = self
        
        addSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: 300, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top - 100)
        field.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 100, width: view.frame.size.width - 20, height: 50)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(field)
        
    }
}

extension LocationListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentLocationCell.identifier, for: indexPath) as? CurrentLocationCell else {fatalError()}
            cell.configure()
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {fatalError()}
            cell.configure(with: locations[indexPath.row - 1].title)
            cell.contentView.backgroundColor = .secondarySystemBackground
            cell.backgroundColor = .secondarySystemBackground
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.setLocation(location: locations[indexPath.row - 1].title)
        self.dismiss(animated: true)
    }
} 

extension LocationListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
        
        return true
    }
}

