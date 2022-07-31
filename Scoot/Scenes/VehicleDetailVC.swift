//
//  VehicleDetailVC.swift
//  Scoot
//
//  Created by Profico on 21.07.2022..
//

import UIKit
import SnapKit
import Reachability

class VehicleDetailVC: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0.154, green: 0.154, blue: 0.154, alpha: 0.7)
        
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "VehicleCell", bundle: nil), forCellReuseIdentifier: VehicleCell.identifier)
        table.contentInset.bottom = 100
        table.separatorStyle = .none
        table.isScrollEnabled = false
        
        return table
    }()
    
    private let scanButton: ScootButton = {
        let button = ScootButton(backgruondColor: .scootPurple500!, title: "SCAN TO START RIDE  ", titleColor: .systemBackground)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        let image = UIImage(named: "qrCodeImage")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let startRideButton: ScootButton = {
        let button = ScootButton(backgruondColor: .scootPurple500!, title: "START RIDE", titleColor: .systemBackground)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        return button
    }()
    
    private var vehicle: VehicleResponse
    private let afterScan: Bool
    private let vehicleResponses: [VehicleResponse]
    private let reachability = try! Reachability()
    
    init(vehicle: VehicleResponse, afterScan: Bool, vehicleResponses: [VehicleResponse]) {
        self.vehicle = vehicle
        self.afterScan = afterScan
        self.vehicleResponses = vehicleResponses
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        view.backgroundColor = UIColor.init(red: 0.154, green: 0.154, blue: 0.154, alpha: 0.7)
        
        backgroundClickListener()
        contentClickListener()
        addSubviews()
        
        configureScanButton()
        configureStartButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureConstraints()
        
        if afterScan {
            scanButton.isHidden = true
            startRideButton.isHidden = false
        }else {
            scanButton.isHidden = false
            startRideButton.isHidden = true
        }
    }
    
    private func addSubviews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(scanButton)
        contentView.addSubview(startRideButton)
    }
    
    private func configureConstraints() {
        backgroundView.frame = view.bounds
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(254)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
        
        scanButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(56)
        }
        
        startRideButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(56)
        }
    }
}

extension VehicleDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.identifier, for: indexPath) as? VehicleCell else {fatalError()}
        cell.configure(with: vehicle)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        guard let distanceString = formatter.string(from: LocationManager.shared.getDistance(for: vehicle) / 1000 as NSNumber) else {return UITableViewCell()}
        
        cell.distanceLabel.text = "\(distanceString) km away"
        return cell
    }
}

private extension VehicleDetailVC {
    func contentClickListener() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(tap)
    }
    
    func backgroundClickListener() {
        let tap = UITapGestureRecognizer(target: self, action: #selector((didTapBackground)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func didTapBackground() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapContent() {
        
        print("content tapped")
    }
    
    @objc func didTapScan() {
        let vc = ScanVC(vehicleModels: vehicleResponses, vehicle: vehicle, afterDetailView: true)
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @objc private func didTapStart() {
        let vc = RideInProgressVC(vehicle: vehicle.vehicleId)
        reachability.whenReachable = { _ in 
            print("internet")
            self.navigationController?.pushViewController(vc, animated: true)
            
            ApiCaller.shared.startRide(vehicleId: self.vehicle.vehicleId)
            UserDefaults.standard.setCurrentVehicle(with: self.vehicle.vehicleId)
            UserDefaults.standard.setTimerStart(date: Date()) 
        } 
        
        do {
            try reachability.startNotifier()
        }catch {
            print("unable to start notifier")
        }
    }
    
    func configureScanButton() {
        scanButton.addTarget(self, action: #selector(didTapScan), for: .touchUpInside)
    }
    
    func configureStartButton() {
        startRideButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
    }
}
