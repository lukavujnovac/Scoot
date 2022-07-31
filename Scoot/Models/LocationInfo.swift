//
//  LocationInfo.swift
//  Scoot
//
//  Created by Luka Vujnovac on 31.07.2022..
//

import Foundation

struct LocationInfo: Codable {
    let lat: Int
    let long: Int
    let locationString: String?
}
