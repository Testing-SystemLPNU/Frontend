//
//  ViewCourseView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

extension NiceButtonStyle {
    static var bigButton: NiceButtonStyle {
        var primaryStyle:NiceButtonStyle = .primary
        primaryStyle.height = 100
        primaryStyle.textStyle.size = 26
        return primaryStyle
    }
}

struct CourseView: View {
    
    @StateObject var hostModel: CourseHostModel
    
    @ViewBuilder
    func courseView() -> some View {
        ZStack {
            NavigationView {
                VStack {
                    NiceButton("Questions", style: .bigButton) {
                        hostModel.goToQuestions()
                    }
                    NiceButton("Tickets", style: .bigButton) {
                        hostModel.goToTickets()
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(hostModel.viewModel.course.title)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
            }
            
            if hostModel.viewModel.showProgressView {
                ProgressView()
            }
        }
    }
    
    var body: some View {
        VStack {
            switch hostModel.viewModel.mode {
            case .main:
                courseView()
            case .questions:
                QuestionsView(hostModel: QuestionsHostModel(course: hostModel.viewModel.course, backAction: hostModel))
            case .tickets:
                TicketsView(hostModel: TicketsHostModel(course: hostModel.viewModel.course, backAction: hostModel))
            }
        }
    }
}
