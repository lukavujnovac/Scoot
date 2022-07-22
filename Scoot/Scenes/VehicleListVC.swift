//
//  VehicleListVC.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit
import CoreLocation

class VehicleListVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "VehicleCell", bundle: nil), forCellReuseIdentifier: VehicleCell.identifier)
        table.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationCell.identifier)
        table.contentInset.bottom = 100
        
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
    
    let vehicles = MockData.vehicles
    
    var manager: CLLocationManager?
    var locationString: String = "no location"
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        tableView.frame = view.frame.insetBy(dx: 0.0, dy: 100.0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        //        tableView.frame = view.bounds
        //        let footerView = UIView()
        //        footerView.frame.size.height = 200
        //        tableView.tableFooterView = footerView
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupLocationManager()
        
//        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn) {
//            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
//            let vc = ScanVC()
//            
//            vc.view.frame = window.bounds
//            window.addSubview(vc.view)
//        }completion: { st in
//            
//        }
    }
    
    private func setupLocationManager() {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
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
        print("scan")
//        navigationController?.pushViewController(ScanVC(), animated: true)
        let vc = ScanVC()
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
}

extension VehicleListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vehicles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return indexPath.row == 0 ? 58 : UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {fatalError()}
            cell.configure(with: locationString)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.identifier, for: indexPath) as? VehicleCell else {fatalError()}
        cell.configure(with: vehicles[indexPath.row])
//        cell.imageWidthConstraint.constant = indexPath.row % 2 == 0 ? 70 : 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
            presentModal(vehicle: self.vehicles[indexPath.row])
        }
        //            navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentModal(vehicle: VehicleModel) {
        let detailViewController = VehicleDetailVC(vehicle: vehicle, afterScan: false)
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .overFullScreen

//            if let sheet = nav.sheetPresentationController {
//                sheet.detents = [.medium()]
//            }
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
        guard let first = locations.first else {return}
        
        let locationLon = "\(first.coordinate.longitude)"
        let locationLat = "\(first.coordinate.latitude)"
        
        getAddressFromLatLon(pdblLatitude: locationLat, withLongitude: locationLon)
        //        locationString = "\(first.coordinate.longitude) / \(first.coordinate.latitude)"
//        print(locationString)
        tableView.reloadData()
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                //                        print(pm.country)
                //                        print(pm.locality)
                //                        print(pm.subLocality)
                //                        print(pm.thoroughfare)
                //                        print(pm.postalCode)
                //                        print(pm.subThoroughfare)
                var addressString : String = ""
                //ulica
                if pm.thoroughfare != nil {
                    addressString += pm.thoroughfare! + ", "
                }
                //broj ulice
                if pm.subThoroughfare != nil {
                    addressString += pm.subThoroughfare! + ", "
                }
                //grad
                if pm.locality != nil {
                    addressString += pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString += pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString += pm.postalCode! + " "
                }
                self.locationString = addressString
            }
        })
    }
}

