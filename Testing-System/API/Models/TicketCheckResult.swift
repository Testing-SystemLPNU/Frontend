//
//  TicketCheckResult.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/19/25.
//

struct TicketCheckResult: Decodable {
    var scrore: Int
    var total: Int
    var corectAnswers: [String: String]
    var yourAnswers: [String: String]
}
