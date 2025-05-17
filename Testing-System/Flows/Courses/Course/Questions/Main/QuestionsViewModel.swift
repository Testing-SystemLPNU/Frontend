//
//  CourseViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

class QuestionsViewModel {
    var course: Course
    var questions: [Question] = []
    var questionToEditAdd: Question? = nil
    var showProgressView: Bool = false
    init(course: Course, showProgressView: Bool = false) {
        self.course = course
        self.showProgressView = showProgressView
    }
}
