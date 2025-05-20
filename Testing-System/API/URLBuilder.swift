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
        // Auth
        case auth
        case signup
        case login
        // Courses
        case courses
        // Questions
        case questions
        // Tickets
        case tickets
        case pdf
        case check
        case groupResults = "group-results"
        case table
        // Generate
        case generate
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
    
    func questions(forCourseWithId id: String) -> URL {
        return courseURL(withId: id)
            .appendingPathComponent(Path.questions.rawValue)
    }
    
    func questionURL(withId id: String, forCourseWithId courseId: String) -> URL {
        return questions(forCourseWithId: courseId)
            .appendingPathComponent(id)
    }
    
    func ticketsURL(forCourseWithId id: String) -> URL {
        return courseURL(withId: id)
            .appendingPathComponent(Path.tickets.rawValue)
    }
    
    func ticketURL(withId id: String, forCourseWithId courseId: String) -> URL {
        return ticketsURL(forCourseWithId: courseId)
            .appendingPathComponent(id)
    }
    
    func ticketPDFurl(withId id: String, forCourseWithId courseId: String) -> URL {
        return ticketURL(withId:id, forCourseWithId: courseId)
            .appendingPathComponent(Path.pdf.rawValue)
    }
    
    func generateQuestionsURL(withId id: String) -> URL {
        return courseURL(withId: id)
            .appendingPathComponent(Path.questions.rawValue)
            .appendingPathComponent(Path.generate.rawValue)
    }
    
    var checkURL: URL {
        return baseURL
            .appendingPathComponent(Path.check.rawValue)
    }
    
    var tableGroupResults: URL {
        return baseURL
            .appendingPathComponent(Path.groupResults.rawValue)
            .appendingPathComponent(Path.table.rawValue)
    }
    
    var pdfGroupResults: URL {
        return baseURL
            .appendingPathComponent(Path.groupResults.rawValue)
            .appendingPathComponent(Path.pdf.rawValue)
    }
}
