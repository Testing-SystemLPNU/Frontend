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
    
    
    private func go(to mode: CourseViewModel.Mode) {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        viewModel.mode = mode
    }
    
//    func loadQuestions() {
//        viewModel.showProgressView = true
//        publishUpdate()
//        AppManager.shared.serialTasks.run { [weak self] in
//            await self?.doLoadQuestions()
//        }
//    }
    
//    func doLoadQuestions() async {
//        defer {
//            viewModel.showProgressView = false
//            publishUpdate()
//        }
//        
//        do {
//            viewModel.questions = try await AppManager.shared.apiConnector.questions(course: viewModel.course)
//        } catch {
//            print("Load questions error: \(error)")
//        }
//    }
    
//    func save() {
//        viewModel.showProgressView = true
//        publishUpdate()
//        viewModel.course.title = viewModel.course.title.trimmingCharacters(in: .whitespacesAndNewlines)
//        viewModel.course.description = viewModel.course.description.trimmingCharacters(in: .whitespacesAndNewlines)
//        viewModel.course.id == nil ?
//        createCourse() :
//        editCourse()
//    }
//    
//    func createCourse() {
//        AppManager.shared.serialTasks.run { [weak self] in
//            await self?.doCreateCourse()
//        }
//    }
//    
//    func editCourse() {
//        
//    }
//    
//    private func doCreateCourse() async {
//        defer {
//            viewModel.showProgressView = false
//            publishUpdate()
//            goBack()
//        }
//        do {
//            try await AppManager.shared.apiConnector.create(course: viewModel.course)
//        } catch {
//            print("Create course error: \(error)")
//        }
//    }
}


extension CourseHostModel: BackNavigation {
    func back() {
        defer {
            publishUpdate()
        }
        viewModel.mode = .main
    }
}
