//
//  UserDefaults + Extensions.swift
//  Scoot
//
//  Created by Profico on 22.07.2022..
//

import Foundation

extension UserDefaults {
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
    func setLocation(location: String) {
        set(location, forKey: "location")
        synchronize()
    }
    
    func getLocation() -> String {
        return string(forKey: "location") ?? "no location"
    }
    
//    func getCurrentLocation() 
}
