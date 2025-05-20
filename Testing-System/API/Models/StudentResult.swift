//
//  StudentResult.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/19/25.
//

struct StudentResult: Decodable {
    let studentName: String
    let ticketId: Int
    let score: Int
    let maxScore: Int
}
