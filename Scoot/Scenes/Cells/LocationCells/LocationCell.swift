//
//  LocationCell.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit
import SnapKit

class LocationCell: UITableViewCell {
    
    static let identifier = "LocationCell"

    @IBOutlet weak var locationPinImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with location: String) {
        locationPinImageView.image = UIImage(named: "locationPinImage")
        locationPinImageView.contentMode = .scaleAspectFit
        
        locationLabel.text = location
        locationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        locationLabel.textColor = .label
    }
}
