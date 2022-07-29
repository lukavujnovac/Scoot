//
//  RideCompletedVC.swift
//  Scoot
//
//  Created by Profico on 29.07.2022..
//

import UIKit
import Cosmos

class RideCompletedVC: UIViewController {
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .scootLoginGreen
        view.layer.cornerRadius = 59.5
        return view
    }()
    
    
    private let backgroundCircleView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill")
        iv.tintColor = .white
        return iv
    }()
    
    private let foregroundCircleView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark")
        iv.tintColor = .scootLoginGreen
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "RIDE COMPLETED"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .scootLoginGreen
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "How was your ride?"
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.textColor = .label
        
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "RIDE INFORMATION"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray5
        
        return label
    }()
    
    private let durationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "clock")
        iv.tintColor = .label
        
        return iv
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "Duration"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .label
        
        return label
    }()
    
    private let durationValueLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.getTimer()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    //
    private let distanceImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "distanceImage-1")
        iv.tintColor = .label
        
        return iv
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .label
        
        return label
    }()
    
    private let distanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0,8 km"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    //
    private let batteryImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "battery.100")
        iv.tintColor = .systemGray
        
        return iv
    }()
    
    private let batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "Battery consuption"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .label
        
        return label
    }()
    
    private let batteryValueLabel: UILabel = {
        let label = UILabel()
        label.text = "6%"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    
    private var cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.emptyImage = UIImage(named: "starNS")
        view.settings.filledImage = UIImage(named: "starS")
        view.settings.starSize = 26
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .scootPurple500!
        button.setTitle("COMPLETE RIDE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .scootLoginGreen
        
        navigationItem.hidesBackButton = true

        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureConstraints()
    }
    
    @objc private func buttonTapped() {
        navigationController?.pushViewController(VehicleListVC(), animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(contentView)
        view.addSubview(imageContainer)
        imageContainer.addSubview(backgroundCircleView)
        imageContainer.addSubview(foregroundCircleView)
        view.bringSubviewToFront(imageContainer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(durationImageView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(durationValueLabel)
        contentView.addSubview(distanceImageView)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(distanceValueLabel)
        contentView.addSubview(batteryImageView)
        contentView.addSubview(batteryLabel)
        contentView.addSubview(batteryValueLabel)
        contentView.addSubview(cosmosView)
        contentView.addSubview(button)
    }
    
    private func configureConstraints() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(136)
        }
        
        imageContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(contentView.snp.top)
            $0.width.height.equalTo(119)
        }
        
        backgroundCircleView.snp.makeConstraints {
            $0.center.equalTo(imageContainer.snp.center)
            $0.width.height.equalTo(93)
        }
        foregroundCircleView.snp.makeConstraints {
            $0.center.equalTo(imageContainer.snp.center)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(130)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(163)
        }
        
        durationImageView.snp.makeConstraints {
            $0.leading.equalTo(infoLabel.snp.leading)
            $0.top.equalTo(infoLabel.snp.bottom).offset(35)
        }
        
        durationLabel.snp.makeConstraints {
            $0.leading.equalTo(durationImageView.snp.trailing).offset(16)
            $0.top.equalTo(durationImageView.snp.top)
        }
        
        durationValueLabel.snp.makeConstraints{
            $0.top.equalTo(durationImageView.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        distanceImageView.snp.makeConstraints {
            $0.leading.equalTo(infoLabel.snp.leading)
            $0.top.equalTo(durationImageView.snp.bottom).offset(35)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(distanceImageView.snp.trailing).offset(16)
            $0.top.equalTo(distanceImageView.snp.top)
        }
        
        distanceValueLabel.snp.makeConstraints{
            $0.top.equalTo(distanceImageView.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        batteryImageView.snp.makeConstraints{
            $0.leading.equalTo(infoLabel.snp.leading)
            $0.top.equalTo(distanceImageView.snp.bottom).offset(35)
        }
        
        batteryLabel.snp.makeConstraints {
            $0.leading.equalTo(batteryImageView.snp.trailing).offset(16)
            $0.top.equalTo(batteryImageView.snp.top)
        }
        
        batteryValueLabel.snp.makeConstraints{
            $0.top.equalTo(batteryImageView.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        cosmosView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(42)
        }
        
        button.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-50)
            $0.height.equalTo(56)
        }
    }
}
