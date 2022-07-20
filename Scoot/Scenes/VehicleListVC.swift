//
//  VehicleListVC.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit

class VehicleListVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "VehicleCell", bundle: nil), forCellReuseIdentifier: VehicleCell.identifier)
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()

        tableView.delegate = self
        tableView.dataSource = self

        view.backgroundColor = .systemBackground
        title = "Available vehicles"
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        configureConstraints()
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
        print("scan ")
        showSpinner()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.hideSpinner()
        }
    }
}

extension VehicleListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vehicles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.identifier, for: indexPath) as? VehicleCell else {fatalError()}
        cell.configure(with: vehicles[indexPath.row])
        
        return cell
    }
}
