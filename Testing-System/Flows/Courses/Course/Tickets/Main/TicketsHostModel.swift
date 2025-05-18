//
//  TicketsHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class TicketsHostModel: BaseHostModel {
    @Published var viewModel: TicketsViewModel
    
    init(course: Course, backAction: BackNavigation) {
        self.viewModel = TicketsViewModel(course: course)
        super.init(backAction: backAction)
    }
    
    func addNewTicket() {
        edit(ticket: Ticket(id: nil, questionIds: [], studentFullName: "", studentGroup: ""))
    }
    
    func edit(ticket: Ticket) {
        viewModel.ticketToEditAdd = ticket
        publishUpdate()
    }
    
    func delete(ticket: Ticket) {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoadTickets()
        }
    }
    
    private func doDelete(ticket: Ticket) async {
        do {
            try await AppManager.shared.apiConnector.delete(ticket: ticket, from: viewModel.course)
        } catch {
            print("Delete ticket error: \(error)")
        }
        
        await doLoadTickets()
    }
    
    func loadTickets() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoadTickets()
        }
    }
    
    private func doLoadTickets() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            viewModel.tickets = try await AppManager.shared.apiConnector.tickets(course: viewModel.course)
        } catch {
            print("Load questions error: \(error)")
        }
    }
}

extension TicketsHostModel: BackNavigation {
    func back() {
        defer {
            publishUpdate()
        }
        viewModel.ticketToEditAdd = nil
    }
}
