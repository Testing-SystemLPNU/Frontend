//
//  AddEditQuestionHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class AddEditQuestionHostModel: BaseHostModel {
    @Published var viewModel: AddEditQuestionViewModel
    
    init(course: Course, question: Question, backAction: BackNavigation) {
        self.viewModel = AddEditQuestionViewModel(course:course, question: question)
        super.init(backAction: backAction)
    }
    
    func save() {
        viewModel.showProgressView = true
        publishUpdate()
        viewModel.question.questionText = viewModel.question.questionText.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.question.optionA = viewModel.question.optionA.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.question.optionB = viewModel.question.optionB.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.question.optionC = viewModel.question.optionC.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.question.optionD = viewModel.question.optionD.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.question.id == nil ?
        create() :
        edit()
    }
    
    func create() {
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doCreate()
        }
    }
    
    func edit() {
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doEdit()
        }
    }
    
    private func doEdit() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
            goBack()
        }
        do {
            try await AppManager.shared.apiConnector.update(question: viewModel.question, at: viewModel.course)
        } catch {
            print("Create question error: \(error)")
        }
    }
    
    private func doCreate() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
            goBack()
        }
        do {
            try await AppManager.shared.apiConnector.create(question: viewModel.question, for: viewModel.course)
        } catch {
            print("Create question error: \(error)")
        }
    }
}
