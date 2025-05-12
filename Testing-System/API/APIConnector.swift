//
//  APIConnector.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/11/25.
//

import Foundation

fileprivate extension String {
    static let get = "GET"
    static let post = "POST"
    static let delete = "DELETE"
    static let put = "PUT"
}

class APIConnector {
    
    struct Constants {
        static let EmptyResult = (nil as EmptyModel?)
    }
    
    enum APIError: Error {
        case invalidResponse
    }
    
    let urlBuilder: URLBuilder
    
    init(baseURL: URL) {
        self.urlBuilder = URLBuilder(baseURL: baseURL)
        
    }
    
    func signup(_ model: SignupRequest) async throws -> LoginResponse {
        return try await send(model, url:urlBuilder.signupURL, method: .post)
    }
    
    func login(_ model: LoginRequest) async throws -> LoginResponse {
        return try await send(model, url:urlBuilder.loginURL, method: .post)
    }
    
    func courses() async throws -> [Course] {
        return try await send(Constants.EmptyResult, url:urlBuilder.coursesURL, method: .get)
    }
    
    @discardableResult
    func create(course: Course) async throws -> Course {
        return try await send(course, url:urlBuilder.coursesURL, method: .post)
    }
    
    func delete(course: Course) async throws {
        guard let id = course.id else {
            return
        }
        _ = try await send(Constants.EmptyResult, url:urlBuilder.courseURL(withId: String(id)), method: .delete) as EmptyModel?
    }
    
    @discardableResult
    private func send<T: Decodable, U: Encodable>(_ body: U? = nil, url: URL, method: String) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            request.httpBody = try? JSONEncoder().encode(body)
            request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let token = AppManager.shared.store.token {
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        var dataToDecode = data
        if method == "DELETE" && dataToDecode.isEmpty {
            dataToDecode = "{}".data(using: .utf8)!
        }
    
        return try JSONDecoder().decode(T.self, from: dataToDecode)
    }
}
