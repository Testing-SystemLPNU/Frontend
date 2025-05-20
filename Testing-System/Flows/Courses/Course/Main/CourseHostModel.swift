//
//  CourseHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class CourseHostModel: BaseHostModel {
    @Published var viewModel: CourseViewModel
    
    init(course: Course, backAction: BackNavigation) {
        self.viewModel = CourseViewModel(course: course)
        super.init(backAction: backAction)
    }
    
    func goToQuestions() {
        go(to: .questions)
    }
    
    func goToTickets() {
        go(to: .tickets)
    }
    
    func goToGroupResults() {
        go(to: .groupResults)
    }
    
    private func go(to mode: CourseViewModel.Mode) {
        viewModel.mode = mode
        publishUpdate()
    }
}


extension CourseHostModel: BackNavigation {
    func back() {
        defer {
            publishUpdate()
        }
        viewModel.mode = .main
    }
}
