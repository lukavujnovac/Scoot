//
//  MockData.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import Foundation

//type status, battery, price, location, model/name, image, ID

struct VehicleModel {
    enum VehicleType {
        case bike
        case scooter
        case skateboard
        
        var string: String {
            switch self {
            case .skateboard: return "skateboard"
            case .scooter: return "scooter"
            case .bike: return "bike"
            }
        }
    }
    
    enum VehicleStatus {
        case available
        case notAvailable
        
        var string: String {
            switch self {
            case .available: return "available"
            case .notAvailable: return "not available"
            }
        }
    }
    
    let type: VehicleType
    let status: VehicleStatus
    let battery: Int
    let price: Float
    let location: String
    let name: String
    let image: String
    let id: String
}

struct MockData {
    static let vehicles = [
        VehicleModel(type: .scooter, status: .available, battery: 99, price: 150.0, location: "2.1", name: "meepo shuffle s (v4s)", image: "scooterImage", id: "1"),
        VehicleModel(type: .bike, status: .available, battery: 99, price: 150.0, location: "2.1", name: "aostirmotor elektrofahrrad 1500", image: "bikeImage", id: "2"),
        VehicleModel(type: .scooter, status: .available, battery: 99, price: 150.0, location: "2.1", name: "meepo shuffle s (v4s)", image: "scooterImage", id: "3"),
        VehicleModel(type: .skateboard, status: .available, battery: 99, price: 150.0, location: "2.1", name: "boundmotor flash", image: "skateboardImage", id: "4"),
        VehicleModel(type: .bike, status: .available, battery: 99, price: 150.0, location: "2.1", name: "aostirmotor elektrofahrrad 1500", image: "bikeImage", id: "5"),
        VehicleModel(type: .skateboard, status: .available, battery: 99, price: 150.0, location: "2.1", name: "boundmotor flash", image: "skateboardImage", id: "6"),
        VehicleModel(type: .skateboard, status: .available, battery: 99, price: 150.0, location: "2.1", name: "boundmotor flash", image: "skateboardImage", id: "7"),
        VehicleModel(type: .skateboard, status: .available, battery: 99, price: 150.0, location: "2.1", name: "boundmotor flash", image: "skateboardImage", id: "8"),
        VehicleModel(type: .skateboard, status: .available, battery: 99, price: 150.0, location: "2.1", name: "boundmotor flash", image: "skateboardImage", id: "9"),
    ]
}
