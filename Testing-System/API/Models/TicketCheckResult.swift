//
//  TicketCheckResult.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/19/25.
//

struct TicketCheckResult: Decodable {
    var score: Int
    var total: Int
    var ticketId: Int
    var studentFullName: String?
    var studentGroup: String?
    var ticketNumber: Int
    var courseName: String?
    var correctAnswers: [String: String]
    var yourAnswers: [String: String]
}
