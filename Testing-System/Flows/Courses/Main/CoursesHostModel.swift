//
//  CoursesHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class CoursesHostModel: BaseHostModel {
    @Published var viewModel: CoursesViewModel = CoursesViewModel()
    
    func loadCourses() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoadCourses()
        }
    }
    
    func addNewCourse() {
        edit(course: Course(id: nil, title: "", description: ""))
    }
    
    func edit(course: Course) {
        viewModel.courseToEditAdd = course
        publishUpdate()
    }
    
    func delete(course: Course) {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doDelete(course: course)
        }
    }
    
    func viewCourse(_ course: Course) {
        viewModel.courseView = course
        publishUpdate()
    }
    
    func showSettings() {
        AppManager.shared.store.token = nil
        goBack()
    }
    
    private func doLoadCourses() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            self.viewModel.courses = try await AppManager.shared.apiConnector.courses()
        } catch {
            print("Loading courses error: \(error)")
        }
    }
    
    private func doDelete(course: Course) async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            try await AppManager.shared.apiConnector.delete(course:course)
            loadCourses()
        } catch {
            print("Deleting course error: \(error)")
        }
    }
}


extension CoursesHostModel: BackNavigation {
    func back() {
        defer {
            publishUpdate()
        }
        viewModel.courseToEditAdd = nil
        viewModel.courseView = nil
    }
}
