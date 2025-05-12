//
//  AddEditCourseViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

class AddEditCourseViewModel {
    var course: Course
    var showProgressView: Bool = false
    init(course: Course, showProgressView: Bool = false) {
        self.course = course
        self.showProgressView = showProgressView
    }
}
