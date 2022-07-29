//
//  ApiCaller.swift
//  Scoot
//
//  Created by Profico on 28.07.2022..
//

import Foundation
import PromiseKit
import SwiftUI

struct ApiCaller {
    static let shared = ApiCaller()
    private let vehicleUrl: String = "https://scoot-ws.proficodev.com/vehicles"
    private let bookingUrl: String = "https://scoot-ws.proficodev.com/bookings/scan"
    private let cancelUrl: String = "https://scoot-ws.proficodev.com/bookings/cancel"
    
    var vehicleIds: [String] = []

    public func fetchVehicles() -> Promise<[VehicleResponse]> {
        let headers: HTTPHeaders = [
            "Authorization" : UserDefaults.standard.getLoginToken()
        ]
        
        Alamofire.request(vehicleUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseString { response in
            print(response)
        }
        
        return Alamofire.request(vehicleUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseDecodable()
    }
    //vehicle.vehicleId
    public func startRide(vehicleId: String) -> Promise <BookingResponse>{
        let params: Parameters = [
            "serialNumber" : vehicleId
        ]
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getLoginToken())"
        ]
        
        return Alamofire.request(bookingUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseDecodable()
    }
    
    public func cancelRide(vehicleId: String) -> Promise <BookingResponse>{
        let params: Parameters = [
            "serialNumber" : vehicleId
        ]
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getLoginToken())"
        ]
        return Alamofire.request(bookingUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseDecodable()
    }
    
    //fali jos za getVehicle kad skeniras qr code
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
//    var distance: Float = 0
}

struct LocationResponse: Codable {
    let locationPoint: LocationInfo
}

struct LocationInfo: Codable {
    let lat: Int
    let long: Int
    let locationString: String?
}

struct BookingResponse: Codable {
    let id: String
    let userId: Int
    let vehicleId: Int
    let startedAt: String
    let updatedAt: String
    let createdAt: String
}
