//
//  VehicleListVC.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit
import CoreLocation
import Reachability

class VehicleListVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "VehicleCell", bundle: nil), forCellReuseIdentifier: VehicleCell.identifier)
        table.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationCell.identifier)
        table.contentInset.bottom = 100
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
    
    private let scanButton: ScootButton = {
        let button = ScootButton(backgruondColor: .scootPurple500!, title: "SCAN", titleColor: .systemBackground)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        return button
    }()
    
    private let scanIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "qrcodeImage")
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .systemBackground
        
        return iv
    }()
    
    private let emptyView = EmptyView(frame: .zero)
    
    private let vehicles = MockData.vehicles
    private var apiCaller = ApiCaller.shared
    private var vehicleModels: [VehicleResponse] = []
    
    private var manager: CLLocationManager?
    private var locationString: String = "no location"
    
    private let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureButton()
        
        view.backgroundColor = .systemBackground
        
        title = "Available vehicles"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "log out", style: .plain, target: self, action: #selector(logOutTapped))
        view.addSubview(emptyView)
        emptyView.isHidden = true
        view.bringSubviewToFront(emptyView)
        
        showSpinner()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        reachability.whenReachable = { reach in
            self.apiCaller.fetchVehicles().done { response in
                self.setupLocationManager()
                self.vehicleModels = response
                self.tableView.reloadData()
            }.catch { error in
                print(error)
            }.finally {
                self.hideSpinner()
                self.checkIsEmpty()
            }   
        }
        reachability.whenUnreachable = { _ in
            print("no internet")
        }
        
        do {
            try reachability.startNotifier()
        }catch {
            print("unable to start notifier")
        }
        
    }
    
    @objc func logOutTapped() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        let vc = LoginVC()
        navigationController?.pushViewController(vc , animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        configureConstraints()
        
        emptyView.frame = view.bounds
    }
    
    private func checkIsEmpty() {
        if vehicleModels.isEmpty  {
            print("no data")
            emptyView.isHidden = false
        }else {
            print("data")
            emptyView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    private func setupLocationManager() {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        tableView.reloadData()
    }
}

private extension VehicleListVC {
    private func addViews() {
        view.addSubview(tableView)
        view.addSubview(scanButton)
        
        scanButton.addSubview(scanIcon)
    }
    
    func configureConstraints() {
        scanButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(56)
        }
        
        scanIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-120)
            $0.top.bottom.equalToSuperview().inset(18.62)
        }
    }
}

private extension VehicleListVC {
    func configureButton() {
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
    }
    
    @objc private func scanTapped() {
        let vc = ScanVC(vehicleModels: vehicleModels, vehicle: nil, afterDetailView: false)
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
}

extension VehicleListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vehicleModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {fatalError()}
            cell.configure(with: UserDefaults.standard.getLocation())
            
            return cell
        }
        
        let vehicleModel = vehicleModels[indexPath.row - 1]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.identifier, for: indexPath) as? VehicleCell else {fatalError()}
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        guard let distanceString = formatter.string(from: LocationManager.shared.getDistance(for: vehicleModel) / 1000 as NSNumber) else {return UITableViewCell()} 
        
        vehicleModels[indexPath.row - 1].distance = LocationManager.shared.getDistance(for: vehicleModel)
        
        self.vehicleModels = self.vehicleModels.sorted(by: {$0.distance ?? 0.0 < $1.distance ?? 0.0})
        
        cell.configure(with: vehicleModels[indexPath.row - 1])
        
        cell.distanceLabel.text = "\(distanceString) km away"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = LocationFinderVC()
            vc.modalPresentationStyle = .formSheet
            vc.didSelectLocation = { [weak self] in
                self?.tableView.reloadData()
            }
            present(vc, animated: true)
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
            presentModal(vehicle: self.vehicleModels[indexPath.row - 1])
        }
        tableView.reloadData()
    }
    
    private func presentModal(vehicle: VehicleResponse) {
        let detailViewController = VehicleDetailVC(vehicle: vehicle, afterScan: false, vehicleResponses: vehicleModels)
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = vehicles.count - 2
        if indexPath.row == lastItem {
            tableView.tableFooterView = showSpinnerFooter()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tableView.tableFooterView = nil
            }
        }
    }
}

extension VehicleListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let first = locations.first else {return}
        LocationManager.shared.locationLon = first.coordinate.longitude
        LocationManager.shared.locationLat = first.coordinate.latitude
        
        let locationLonString = "\(first.coordinate.longitude)"
        let locationLatString = "\(first.coordinate.latitude)"
        
        LocationManager.shared.getAddressFromLatLon(pdblLatitude: locationLatString, withLongitude: locationLonString)
        tableView.reloadData()
    }
}

