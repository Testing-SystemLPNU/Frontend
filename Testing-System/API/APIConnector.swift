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
        case wrongBody
    }
    
    let urlBuilder: URLBuilder
    
    init(baseURL: URL) {
        self.urlBuilder = URLBuilder(baseURL: baseURL)
        
    }
    
    // MARK: - Login & Sign up
    
    func signup(_ model: SignupRequest) async throws -> LoginResponse {
        return try await send(model, url:urlBuilder.signupURL, method: .post)
    }
    
    func login(_ model: LoginRequest) async throws -> LoginResponse {
        return try await send(model, url:urlBuilder.loginURL, method: .post)
    }
    
    // MARK: - Courses
    
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
    
    // MARK: - Questions
    
    func questions(course: Course) async throws -> [Question] {
        guard let id = course.id else {
            return []
        }
        
        return try await send(Constants.EmptyResult, url: urlBuilder.questions(forCourseWithId: String(id)), method: .get)
    }
    
    @discardableResult
    func create(question: Question, for course: Course) async throws -> Question {
        guard let id = course.id else {
            throw APIError.wrongBody
        }
        
        return try await send(question, url:urlBuilder.questions(forCourseWithId: String(id)), method: .post)
    }
    
    func delete(question: Question, from course: Course) async throws {
        guard let questionID = question.id,
              let courseId = course.id else {
            return
        }
        
        let url = urlBuilder.questionURL(withId: String(questionID), forCourseWithId: String(courseId))
        _ = try await send(Constants.EmptyResult, url:url, method: .delete) as EmptyModel?
    }
    
    @discardableResult
    func update(question: Question, at course: Course) async throws -> Question {
        guard let questionID = question.id,
              let courseId = course.id else {
            throw APIError.wrongBody
        }
        let url = urlBuilder.questionURL(withId: String(questionID), forCourseWithId: String(courseId))
        return try await send(question, url:url, method: .put)
    }
    
    // MARK: - Private
    
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
        
        if httpResponse.statusCode == 401 {
            AppManager.shared.store.token = nil
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
