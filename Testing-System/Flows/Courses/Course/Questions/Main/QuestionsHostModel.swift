//
//  CourseHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class QuestionsHostModel: BaseHostModel {
    @Published var viewModel: QuestionsViewModel
    
    init(course: Course, backAction: BackNavigation) {
        self.viewModel = QuestionsViewModel(course: course)
        super.init(backAction: backAction)
    }
    
    func loadQuestions() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoadQuestions()
        }
    }
    
    func doLoadQuestions() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            viewModel.questions = try await AppManager.shared.apiConnector.questions(course: viewModel.course)
        } catch {
            print("Load questions error: \(error)")
        }
    }
    
    func showFileImport() {
        viewModel.presentImportFile = true
        publishUpdate()
    }
    
    func showBloomGeneration() {
        viewModel.showBloomGeneration = true
        publishUpdate()
    }
    
    func generateQuestionsFromFile(at url: URL) {
        AppManager.shared.serialTasks.run { [weak self] in

            let access = url.startAccessingSecurityScopedResource()
            defer {
                if access {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            await self?.doGenerateQuestionsFromFile(at: url)
        }
    }
    
    private func doGenerateQuestionsFromFile(at url: URL) async {
        do {
            try await AppManager.shared.apiConnector.generateQuestionsFromFile(at: url, for: viewModel.course)
        } catch {
            print("Generate questions error: \(error)")
        }
        await doLoadQuestions()
    }
    
    func addNewQuestion() {
        edit(question: Question(id: nil, questionText: "", optionA: "", optionB: "", optionC: "", optionD: "", correctOption: .A))
    }
    
    func edit(question: Question) {
        viewModel.questionToEditAdd = question
        publishUpdate()
    }
      
    func delete(question:Question) {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doDelete(question: question)
        }
    }
    
    private func doDelete(question: Question) async {
        defer {
            loadQuestions()
        }
        do {
            try await AppManager.shared.apiConnector.delete(question: question, from: viewModel.course)
        } catch {
            print("Delete question error: \(error)")
        }
    }
}


extension QuestionsHostModel: BackNavigation {
    func back() {
        defer {
            publishUpdate()
        }
        viewModel.questionToEditAdd = nil
        viewModel.showBloomGeneration = false
    }
}
