//
//  AddEditQuestionViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//
import Foundation

class BloomGenerationViewModel {
    let course: Course
    var showProgressView: Bool = false
    var presentImportFile: Bool = false
    var selectedFile: URL? = nil
    var selectedLevel: BloomGenerationLevel = .remember
    init(course: Course,showProgressView: Bool = false) {
        self.course = course
        self.showProgressView = showProgressView
    }
}

enum BloomGenerationLevel: Int, CaseIterable, Identifiable {
    case remember, understand, apply, create, analyze
    var stringValue: String {
        switch self {
        case .remember: return "Remember"
        case .understand: return "Understand"
        case .apply: return "Apply"
        case .create: return "Create"
        case .analyze: return "Analyze"
        }
    }
    var id: Self { self }
}

//enum Option: String, Codable, CaseIterable, Identifiable {
//    case A
//    case B
//    case C
//    case D
//    var id: Self { self }
//}
