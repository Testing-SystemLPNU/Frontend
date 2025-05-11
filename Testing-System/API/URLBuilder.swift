//
//  URLBuilder.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/11/25.
//

import Foundation

class URLBuilder {
    
    var baseURL: URL
    
    enum Path: String {
        case auth
        case signup
        case login
    }
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    var signupURL: URL {
        return baseURL
            .appendingPathComponent(Path.auth.rawValue)
            .appendingPathComponent(Path.signup.rawValue)
    }
    
    var loginURL: URL {
        return baseURL
            .appendingPathComponent(Path.auth.rawValue)
            .appendingPathComponent(Path.login.rawValue)
    }
}
