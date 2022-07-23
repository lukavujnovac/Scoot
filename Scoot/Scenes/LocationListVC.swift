//
//  LocationListVC.swift
//  Scoot
//
//  Created by Profico on 22.07.2022..
//

import UIKit

class LocationListVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationCell.identifier)
        
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
}

extension LocationListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {fatalError()}
        cell.configure(with: "Makarska 26, Split")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
