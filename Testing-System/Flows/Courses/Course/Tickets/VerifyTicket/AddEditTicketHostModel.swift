//
//  AddEditTicketHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class AddEditTicketHostModel: BaseHostModel {
    @Published var viewModel: AddEditTicketViewModel
    
    init(course: Course, ticket: Ticket, backAction: BackNavigation) {
        self.viewModel = AddEditTicketViewModel(course:course, ticket: ticket)
        super.init(backAction: backAction)
    }
    
    func isSelected(question: Question) -> Bool {
        guard let id = question.id else {
            return false
        }
        return viewModel.ticket.questionIds.contains(id)
    }
    
    func deselect(question: Question) {
        viewModel.ticket.questionIds.removeAll { id in
            question.id == id
        }
        publishUpdate()
    }
    
    func select(question: Question) {
        guard let id = question.id else {
            return
        }
        viewModel.ticket.questionIds.append(id)
        publishUpdate()
    }
    
    func save() {
        viewModel.showProgressView = true
        publishUpdate()
        viewModel.ticket.studentGroup = viewModel.ticket.studentGroup.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.ticket.studentFullName = viewModel.ticket.studentFullName.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.ticket.id == nil ?
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
            try await AppManager.shared.apiConnector.update(ticket: viewModel.ticket, at: viewModel.course)
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
            try await AppManager.shared.apiConnector.create(ticket: viewModel.ticket, for: viewModel.course)
        } catch {
            print("Create question error: \(error)")
        }
    }
    
    func loadQuestions() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoadQuestions()
        }
    }
    
    private func doLoadQuestions() async {
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
    
    
    func sharePDF() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doSharePDF()
        }
    }
    
    func doSharePDF() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            
            try await AppManager.shared.apiConnector.update(ticket: viewModel.ticket, at: viewModel.course)
            let pdfData = try await AppManager.shared.apiConnector.pdf(ticket: viewModel.ticket, for: viewModel.course)
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "ticket_\( viewModel.ticket.id ?? 0)_\(viewModel.ticket.studentGroup)_\((viewModel.ticket.studentFullName)).pdf"
            let fileURL = tempDir.appendingPathComponent(fileName)
            try pdfData.write(to: fileURL)
            viewModel.pdfURL = fileURL
        } catch {
            print("Load PDF error: \(error)")
        }
    }
}
