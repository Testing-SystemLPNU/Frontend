//
//  AddEditQuestionViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

class AddEditQuestionViewModel {
    let course: Course
    var question: Question
    var showProgressView: Bool = false
    init(course: Course, question: Question, showProgressView: Bool = false) {
        self.course = course
        self.question = question
        self.showProgressView = showProgressView
    }
}
