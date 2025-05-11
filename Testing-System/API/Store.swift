//
//  Store.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation
import KeychainSwift

final class Store {
    struct Constants {
        static let tokenKey = "token_key"
    }
    let keychain = KeychainSwift()
    let userDefaults = UserDefaults()
    var token: String? {
        get {
            guard let tokenHash = userDefaults.value(forKey: Constants.tokenKey) as? String,
                  let token = keychain.get(tokenHash)
            else {
                cleanUp()
                return nil
            }
            
            if token.isEmpty || tokenHash.isEmpty {
                cleanUp()
                return nil
            }
            
            if tokenHash != token.hashString {
                cleanUp()
                return nil
            }
            
            return token
        }
        
        set {
            guard let token = newValue else {
                cleanUp()
                return
            }
            
            let tokenHash = token.hashString
            keychain.set(token, forKey: token)
            userDefaults.set(tokenHash, forKey: Constants.tokenKey)
        }
    }
    
    private func cleanUp() {
        keychain.delete(Constants.tokenKey)
        userDefaults.removeObject(forKey: Constants.tokenKey)
    }
}
