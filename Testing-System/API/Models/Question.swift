//
//  Question.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/17/25.
//

struct Question: Codable {
    enum Option: String, Codable, CaseIterable, Identifiable {
        case A
        case B
        case C
        case D
        var id: Self { self }
    }

    let id: Int?
    var questionText: String
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
    var correctOption: Option
}
