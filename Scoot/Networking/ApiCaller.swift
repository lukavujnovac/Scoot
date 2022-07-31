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
}
