//
//  AuthService.swift
//  Scoot
//
//  Created by Profico on 22.07.2022..
//

import Foundation
import PromiseKit

class AuthService {
    static let shared = AuthService()
    
    let user = MockData.user
    let loginUrl = "https://scoot-ws.proficodev.com/users/login"
    
    public func checkUserInfo(username: String, password: String) -> Bool {
        if user.username == username && user.password == password {
            UserDefaults.standard.setIsLoggedIn(value: true)
            return true
        }else {
            UserDefaults.standard.setIsLoggedIn(value: false)
            return false
        }
    }
    
    public func loginUser(email: String, pass: String) -> Promise<LoginResponse> {
        let params: Parameters = [
            "email" : email,
            "password" : pass
        ] as! [String:String]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept" : "application/json"
        ]
        
        return Alamofire.request(self.loginUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseDecodable()
    }
}
