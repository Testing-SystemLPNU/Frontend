//
//  AddEditTicketViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import PDFKit

class GroupResultsViewModel {
    let course: Course
    var showProgressView: Bool = false
    var groupName: String = ""
    var results: [StudentResult] = []
    var pdfURL: URL? = nil
    init(course: Course) {
        self.course = course
    }
}
