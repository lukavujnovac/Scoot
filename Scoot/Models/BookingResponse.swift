//
//  BookingResponse.swift
//  Scoot
//
//  Created by Luka Vujnovac on 31.07.2022..
//

import Foundation

struct BookingResponse: Codable {
    let id: String
    let userId: Int
    let vehicleId: Int
    let startedAt: String
    let updatedAt: String
    let createdAt: String
}
