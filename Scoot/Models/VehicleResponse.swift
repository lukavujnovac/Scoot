//
//  VehicleResponse.swift
//  Scoot
//
//  Created by Luka Vujnovac on 31.07.2022..
//

import Foundation

struct VehicleResponse: Codable {
    let id: Int
    let avatar: String
    let vehicleName: String
    let vehicleType: String
    let vehicleId: String
    let vehicleStatus: Bool
    let vehicleBattery: String
    let location: LocationResponse
    var distance: Double?
}
