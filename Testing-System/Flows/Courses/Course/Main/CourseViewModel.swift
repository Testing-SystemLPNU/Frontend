//
//  CourseViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

class CourseViewModel {
    enum Mode {
        case main
        case questions
        case tickets
    }
    var course: Course
    var mode: Mode = .main
    var showProgressView: Bool = false
    init(course: Course, showProgressView: Bool = false) {
        self.course = course
        self.showProgressView = showProgressView
    }
}
