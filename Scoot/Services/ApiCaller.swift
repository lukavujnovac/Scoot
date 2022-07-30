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
    private let vehiclesUrl: String = "https://scoot-ws.proficodev.com/vehicles"
    private let bookingUrl: String = "https://scoot-ws.proficodev.com/bookings/scan"
    private let cancelUrl: String = "https://scoot-ws.proficodev.com/bookings/cancel"
    private let vehicleUrl: String = "https://scoot-ws.proficodev.com/vehicles"
    
    public func fetchVehicles() -> Promise<[VehicleResponse]> {
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getLoginToken())"
        ]
        
        return Alamofire.request(vehiclesUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseDecodable()
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
    
    public func getVehicle(vehicleId: String) -> Promise<[VehicleCodeResponse]> {
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.getLoginToken())"
        ]
        
        let params: Parameters = [
            "serialNumber" : vehicleId
        ]
        
        print("izvrsila se funkcija")
        
        let url = vehicleUrl + vehicleId
//        print(url)
        
        return Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseDecodable()
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
    var distance: Double?
}

struct VehicleCodeResponse: Codable {
    let id: Int
    let avatar: String
    let type: String?
    let availability: Bool?
    let battery: String?
    let price: Int?
    let lat: Int?
    let lang: Int?
    let name: String?
    let serialNumber: String?
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
