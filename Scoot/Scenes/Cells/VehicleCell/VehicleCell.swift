//
//  VehicleCell.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit
import SnapKit
import Kingfisher

class VehicleCell: UITableViewCell {

    static let identifier = "VehicleCell"
    
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

        distanceLabel.text = "SAM IZRACUNAT"
        distanceIndicatorView.layer.cornerRadius = 4
    }
}
