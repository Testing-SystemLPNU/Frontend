//
//  APIConnector.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/11/25.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

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
    
    // MARK: - Tickets
    
    func tickets(course: Course) async throws -> [Ticket] {
        guard let id = course.id else {
            return []
        }
        
        return try await send(Constants.EmptyResult, url: urlBuilder.ticketsURL(forCourseWithId: String(id)), method: .get)
    }
    
    @discardableResult
    func create(ticket: Ticket, for course: Course) async throws -> Ticket {
        guard let id = course.id else {
            throw APIError.wrongBody
        }
        
        return try await send(ticket, url:urlBuilder.ticketsURL(forCourseWithId: String(id)), method: .post)
    }
    
    func delete(ticket: Ticket, from course: Course) async throws {
        guard let ticketID = ticket.id,
              let courseId = course.id else {
            return
        }
        
        let url = urlBuilder.ticketURL(withId: String(ticketID), forCourseWithId: String(courseId))
        _ = try await send(Constants.EmptyResult, url:url, method: .delete) as EmptyModel?
    }
    
    @discardableResult
    func update(ticket: Ticket, at course: Course) async throws -> EmptyModel {
        guard let ticketID = ticket.id,
              let courseId = course.id else {
            throw APIError.wrongBody
        }
        let url = urlBuilder.ticketURL(withId: String(ticketID), forCourseWithId: String(courseId))
        return try await send(ticket, url:url, method: .put)
    }
    
    func pdf(ticket: Ticket, for course: Course) async throws -> Data {
        guard let ticketID = ticket.id,
              let courseId = course.id else {
            throw APIError.wrongBody
        }
        
        let url = urlBuilder.ticketPDFurl(withId: String(ticketID), forCourseWithId: String(courseId))
        
        return try await getData(Constants.EmptyResult, url: url, method: .get)
    }
    
    @discardableResult
    func generateQuestionsFromFile(at fileUrl: URL, for course: Course) async throws -> [Question] {
        guard let courseId = course.id else {
            throw APIError.wrongBody
        }
        
        let url = urlBuilder.generateQuestionsURL(withId: String(courseId))
        
        let (data, response) = try await uploadFileMultipart(fileURL: fileUrl, to: url)
        try handleResponse(response)
        return try JSONDecoder().decode([Question].self, from: data)
    }
    
    func checkTicket(image: UIImage, for course: Course) async throws -> TicketCheckResult {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            throw APIError.wrongBody
        }
        
        let url = urlBuilder.checkURL
        let (data, response) = try await uploadFileMultipart(fileData: imageData, to: url)
        try handleResponse(response)
        return try JSONDecoder().decode(TicketCheckResult.self, from: data)
    }
    
    func getGroupResults(name: String) async throws -> [StudentResult] {
        if name.isEmpty {
            throw APIError.wrongBody
        }
        
        let url = urlBuilder.tableGroupResults
        return try await send(GroupName(group: name), url:url, method: .get)
    }
    
    func pdfGroupResults(name: String) async throws -> Data {
        if name.isEmpty {
            throw APIError.wrongBody
        }
        
        let url = urlBuilder.pdfGroupResults
        return try await getData(GroupName(group: name), url: url, method: .get)
    }
    
    // MARK: - Private
    
    private func handleResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
    }
    
    private func getData<U: Encodable>(_ body: U? = nil, url: URL, method: String) async throws -> Data {
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
        try handleResponse(response)
        
        if method == "DELETE" && data.isEmpty {
            return "{}".data(using: .utf8)!
        }
        return data
    }
    
    @discardableResult
    private func send<T: Decodable, U: Encodable>(_ body: U? = nil, url: URL, method: String) async throws -> T {
        let dataToDecode = try await getData(body, url: url, method: method)
    
        return try JSONDecoder().decode(T.self, from: dataToDecode)
    }
    
    
    private func uploadFileMultipart(
        fileData: Data,
        to serverURL: URL,
        fieldName: String = "file",
        fileName: String = "file",
        mimeType: String = "application/octet-stream"
    ) async throws -> (Data, URLResponse) {
        let boundary = UUID().uuidString
        var request = URLRequest(url: serverURL)
        request.httpMethod = .post
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5 * 60.0
        if let token = AppManager.shared.store.token {
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Build multipart/form-data body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // Upload using async/await
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: body)

        return (responseData, response)
    }

    private func uploadFileMultipart(
        fileURL: URL,
        to serverURL: URL,
        fieldName: String = "file"
    ) async throws -> (Data, URLResponse) {
        // Read file data
        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        let mimeType = mimeTypeForPath(fileURL.path)
        return try await uploadFileMultipart(fileData: fileData,
                                             to: serverURL,
                                             fileName: filename,
                                             mimeType: mimeType)
    }

    private func mimeTypeForPath(_ path: String) -> String {
        let pathExtension = URL(fileURLWithPath: path).pathExtension
        if let utType = UTType(filenameExtension: pathExtension),
           let mimeType = utType.preferredMIMEType {
            return mimeType
        }
        return "application/octet-stream"
    }
}
