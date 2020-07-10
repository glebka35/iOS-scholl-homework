//
//  Defaults.swift
//  Registration
//
//  Created by Gleb Uvarkin on 10.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

struct Defaults {
    private static let userDefaults = UserDefaults.standard
    static let userSessionKey = "com.save.userinfo"
    static let (loginKey, passwordKey) = ("login", "password")
    
    struct UserDetails {
        let login: String?
        let password: String?
        
        init(login: String, password: String) {
            self.login = login
            self.password = password
        }
        
        init(_ json: [String: String]) {
            self.login = json[loginKey]
            self.password = json[passwordKey]
        }
    }
    
    static func save(userDetails: UserDetails) {
        userDefaults.set([loginKey: userDetails.login, passwordKey: userDetails.password], forKey: userSessionKey)
    }
    
    static func getLoginAndPassword()->UserDetails? {
        if let json = userDefaults.value(forKey: userSessionKey) as? [String: String] {
            return UserDetails(json)
        }
        return nil
    }
    
    static func clearUserData() {
        userDefaults.removeObject(forKey: userSessionKey)
    }
    
}
