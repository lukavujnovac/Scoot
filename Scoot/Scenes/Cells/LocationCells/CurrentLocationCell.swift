//
//  CurrentLocationCell.swift
//  Scoot
//
//  Created by Luka Vujnovac on 23.07.2022..
//

import UIKit

class CurrentLocationCell: UITableViewCell {
    
    static let identifier: String = "CurrentLocationCell"

    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure() {
        pinImageView.image = UIImage(systemName: "location.fill")
        pinImageView.tintColor = .scootLoginGreen
        
        currentLocationLabel.text = "Current location"
        currentLocationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        currentLocationLabel.textColor = .label
    }
    
}
