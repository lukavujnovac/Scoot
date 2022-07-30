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
    
    func setLoginToken(value: String) {
        set(value, forKey: "LoginToken")
        synchronize()
    }
    
    func getLoginToken() -> String {
        return string(forKey: "LoginToken") ?? ""
    }
    
    func setTimer(value: String) {
        set(value, forKey: "timerValue")
        synchronize()
    }
    
    func getTimer() -> String {
        return string(forKey: "timerValue") ?? "0s"
    }
    
    func setTimerStart(date: Date?) {
        set(date, forKey: "timerStart")
        synchronize()
    }
    
    func getTimerStart() -> Any? {
        return object(forKey: "timerStart")
    }
    
    func setCurrentVehicle(with id: String) {
        set(id, forKey: "vehicleInUseId")
        synchronize()
    }
    
    func getCurrentVehicle() -> String? {
        return string(forKey: "vehicleInUseId")
    }
}
