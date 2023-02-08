//
//  OAuth2tokenStorage.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    private var userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
