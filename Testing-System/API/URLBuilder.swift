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
        // MARK: - Auth
        case auth
        case signup
        case login
        // MARK: - Courses
        case courses
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
    
    var coursesURL: URL {
        return baseURL
            .appendingPathComponent(Path.courses.rawValue)
    }
    
    func courseURL(withId id: String) -> URL {
        return coursesURL
            .appendingPathComponent(id)
    }
}
