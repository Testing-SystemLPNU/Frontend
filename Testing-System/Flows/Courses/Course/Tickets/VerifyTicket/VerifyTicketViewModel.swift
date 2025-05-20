//
//  AddEditTicketViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import PDFKit

class VerifyTicketViewModel {
    let course: Course
    var ticket: Ticket
    var showProgressView: Bool = false
    var showCameraView: Bool = true
    var results: TicketCheckResult? = nil
    init(course: Course, ticket: Ticket) {
        self.course = course
        self.ticket = ticket    }
}
