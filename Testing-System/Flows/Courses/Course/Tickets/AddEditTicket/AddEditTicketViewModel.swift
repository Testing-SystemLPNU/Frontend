//
//  AddEditTicketViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import PDFKit

class AddEditTicketViewModel {
    let course: Course
    var ticket: Ticket
    var showProgressView: Bool = false
    var questions: [Question] = []
    var showVerifyView: Bool = false
    var pdfURL: URL? = nil
    init(course: Course, ticket: Ticket, showProgressView: Bool = false) {
        self.course = course
        self.ticket = ticket
        self.showProgressView = showProgressView
    }
}
