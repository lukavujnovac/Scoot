//
//  VehicleCell.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit
import SnapKit
import Kingfisher
import CoreLocation

class VehicleCell: UITableViewCell {

    static let identifier = "VehicleCell"
    
    var distance = ""
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var batteryIndicatorView: UIView!
    @IBOutlet weak var distanceIndicatorView: UIView!
    @IBOutlet weak var batteryImage: UIImageView!
    @IBOutlet weak var distanceImage: UIImageView!
    @IBOutlet weak var batteryPercentage: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with vehicle: VehicleResponse) {
        
        if let url = URL(string: vehicle.avatar) {
            vehicleImage.kf.setImage(with: url)
        }

        vehicleName.text = vehicle.vehicleName
        vehicleTypeLabel.text = vehicle.vehicleType
        batteryPercentage.text = vehicle.vehicleBattery
        batteryIndicatorView.layer.cornerRadius = 4
        
        let strArr = vehicle.vehicleBattery.split(separator: " ")

        for item in strArr {
            let part = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

            if let intVal = Int(part) {
                switch intVal {
                case 0 ..< 30:
                    batteryImage.image = UIImage(systemName:  "battery.25")
                    batteryImage.tintColor = .systemRed
                case 30 ..< 76:
                    batteryImage.image = UIImage(systemName: "battery.50")
                    batteryImage.tintColor = .yellow
                case 76 ... 100:
                    batteryImage.image = UIImage(systemName: "battery.100")
                    batteryImage.tintColor = .scootLoginGreen
                default:
                    batteryImage.image = UIImage(systemName: "battery.0")
                    batteryImage.tintColor = .label
                }
            }
        }

        distanceLabel.text = "-"
        distanceIndicatorView.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        vehicleImage.image = nil
        vehicleName.text = nil
        vehicleTypeLabel.text = nil
        batteryPercentage.text = nil
        distanceLabel.text = nil
    }
}
