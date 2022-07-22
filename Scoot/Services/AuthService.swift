//
//  AuthService.swift
//  Scoot
//
//  Created by Profico on 22.07.2022..
//

import Foundation

class AuthService {
    static let shared = AuthService()
    
    let user = MockData.user
    
    public func checkUserInfo(username: String, password: String) -> Bool {
        if user.username == username && user.password == password {
            print("moze se logirat")
            UserDefaults.standard.setIsLoggedIn(value: true)
            return true
        }else {
            print("ne moze se logirat")
            UserDefaults.standard.setIsLoggedIn(value: false)
            return false
        }
    }
}
