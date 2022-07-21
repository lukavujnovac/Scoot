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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        configureConstraints()
    }
    
    func configure(with location: String) {
        locationPinImageView.image = UIImage(named: "locationPinImage")
        locationPinImageView.contentMode = .scaleAspectFit
        
        locationLabel.text = location
        locationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        locationLabel.textColor = .label
    }
    
    private func configureConstraints() {
        locationPinImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(11)
        }
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationPinImageView.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview().inset(21)
        }
    }
    
}
