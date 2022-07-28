//
//  ApiCaller.swift
//  Scoot
//
//  Created by Profico on 28.07.2022..
//

import Foundation
import PromiseKit

struct ApiCaller {
    static let shared = ApiCaller()
    private let url: String = "https://scoot-ws.proficodev.com/vehicles"

    public func fetchVehicles() -> Promise<[VehicleResponse]> {
        return Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable()
    }
}

struct VehicleResponse: Codable {
    let id: Int
    let avatar: String
    let vehicleName: String
    let vehicleType: String
    let vehicleId: String
    let vehicleStatus: Bool
    let vehicleBattery: String
    let location: LocationResponse
}

struct LocationResponse: Codable {
    let locationPoint: LocationInfo
}

struct LocationInfo: Codable {
    let lat: Int
    let long: Int
    let locationString: String?
}
