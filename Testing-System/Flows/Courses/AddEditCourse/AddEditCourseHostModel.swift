//
//  AddEditCourseHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class AddEditCourseHostModel: BaseHostModel {
    @Published var viewModel: AddEditCourseViewModel
    
    init(course: Course, backAction: BackNavigation) {
        self.viewModel = AddEditCourseViewModel(course: course)
        super.init(backAction: backAction)
    }
    
    func save() {
        viewModel.showProgressView = true
        publishUpdate()
        viewModel.course.title = viewModel.course.title.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.course.description = viewModel.course.description.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.course.id == nil ?
        createCourse() :
        editCourse()
    }
    
    func createCourse() {
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doCreateCourse()
        }
    }
    
    func editCourse() {
        
    }
    
    private func doCreateCourse() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
            goBack()
        }
        do {
            try await AppManager.shared.apiConnector.create(course: viewModel.course)
        } catch {
            print("Create course error: \(error)")
        }
    }
}
