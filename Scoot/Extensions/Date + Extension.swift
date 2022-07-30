//
//  Date + Extension.swift
//  Scoot
//
//  Created by Luka Vujnovac on 30.07.2022..
//

import Foundation

extension Date {

    static func getTimeInterval (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
