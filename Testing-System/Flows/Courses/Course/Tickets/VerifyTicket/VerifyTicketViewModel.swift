//
//  AddEditTicketViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import PDFKit

class VerifyTicketViewModel {
    let course: Course
    var showProgressView: Bool = false
    var showCameraView: Bool = true
    var results: TicketCheckResult? = nil
    init(course: Course) {
        self.course = course
    }
}
