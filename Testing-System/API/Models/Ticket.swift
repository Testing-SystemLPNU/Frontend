//
//  Ticket.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/17/25.
//

import Foundation

struct Ticket: Codable {
    let id: Int?
    var questionIds: [Int]
    var studentFullName: String
    var studentGroup: String
}
