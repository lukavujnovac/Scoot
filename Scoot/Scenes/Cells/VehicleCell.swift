//
//  VehicleCell.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit
import SnapKit

class VehicleCell: UITableViewCell {

    static let identifier = "VehicleCell"
    
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var batteryIndicatorView: UIView!
    @IBOutlet weak var distanceIndicatorView: UIView!
    
    private let batteryImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "batteryImage")
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    private let batteryPercentage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .systemBackground
        
        return label
    }()
    
    private let distanceImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "distanceImage")
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .label
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vehicle: VehicleModel) {
        vehicleImage.image = UIImage(named: vehicle.image)
        
        vehicleName.text = vehicle.name.uppercased()
        vehicleName.font = .systemFont(ofSize: 20, weight: .bold)
        vehicleName.textColor = .label
        
        vehicleTypeLabel.text = vehicle.type.string.uppercased()
        vehicleTypeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        vehicleTypeLabel.textColor = .scootPurple500
        
        batteryIndicatorView.addSubview(batteryImage)
        batteryIndicatorView.addSubview(batteryPercentage)
        batteryPercentage.text = "\(vehicle.battery)%"
        batteryPercentage.textColor = .systemBackground
        batteryIndicatorView.backgroundColor = .label
        batteryIndicatorView.layer.cornerRadius = 4
        
        distanceIndicatorView.addSubview(distanceImage)
        distanceIndicatorView.addSubview(distanceLabel)
        distanceLabel.text = "\(vehicle.location) km away"
        distanceLabel.textColor = .label
        distanceIndicatorView.backgroundColor = .systemGray2
        distanceIndicatorView.layer.cornerRadius = 4
    }
    
    private func configureConstraints() {
        vehicleImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(88)
            $0.width.equalTo(70)
        }
        
        vehicleName.snp.makeConstraints {
            $0.leading.equalTo(vehicleImage.snp.trailing).offset(16)
            $0.top.equalTo(vehicleTypeLabel.snp.bottom).offset(4)
        }
        
        vehicleTypeLabel.snp.makeConstraints {
            $0.leading.equalTo(vehicleImage.snp.trailing).offset(16)
            $0.top.equalTo(vehicleImage.snp.top)
        }
        
        batteryIndicatorView.snp.makeConstraints {
            $0.leading.equalTo(vehicleImage.snp.trailing).offset(16)
            $0.top.equalTo(vehicleName.snp.bottom).offset(22)
            $0.width.equalTo(67)
            $0.height.equalTo(24)
        }
        
        batteryImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9)
            $0.top.bottom.equalToSuperview().inset(8.5)
        }
        
        batteryPercentage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-9)
            $0.top.bottom.equalToSuperview().inset(4)
            
        }
        
        distanceIndicatorView.snp.makeConstraints {
            $0.leading.equalTo(batteryIndicatorView.snp.trailing).offset(8)
            $0.top.equalTo(batteryIndicatorView.snp.top)
            $0.width.equalTo(114)
            $0.height.equalTo(24)
        }
        
        distanceImage.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(9)
            $0.top.bottom.equalToSuperview().inset(8.5)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-9)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }
    
}
