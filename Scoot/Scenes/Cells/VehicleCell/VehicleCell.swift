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
    
    func configure(with vehicle: VehicleModel) {
        vehicleImage.image = UIImage(named: vehicle.image)

        vehicleName.text = vehicle.name.uppercased()

        vehicleTypeLabel.text = vehicle.type.string.uppercased()

        batteryPercentage.text = "\(vehicle.battery)%"
        batteryIndicatorView.layer.cornerRadius = 4

        distanceLabel.text = "\(vehicle.location) km away"
        distanceIndicatorView.layer.cornerRadius = 4
    }
}
