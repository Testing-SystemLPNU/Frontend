//
//  TicketsViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

class TicketsViewModel {
    var course: Course
    var tickets: [Ticket] = []
    var ticketToEditAdd: Ticket? = nil
    var showProgressView: Bool = false
    var showVerifyView: Bool = false
    init(course: Course, showProgressView: Bool = false) {
        self.course = course
        self.showProgressView = showProgressView
    }
}
