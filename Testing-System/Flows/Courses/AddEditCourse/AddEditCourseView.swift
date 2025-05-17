//
//  AddEditCourseView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct AddEditCourseView: View {
    
    @StateObject var hostModel: AddEditCourseHostModel
    
    var isEditCourse: Bool {
        return hostModel.viewModel.course.id != nil
    }
    
    @ViewBuilder
    func courseView() -> some View {
        ZStack {
            NavigationView {
                VStack {
                    NiceTextField($hostModel.viewModel.course.title,
                                  placeholder: "Title")
                    NiceTextField($hostModel.viewModel.course.description,
                                  placeholder: "Description")
                    Spacer()
                }
                .padding(.top, 15)
            }
            .navigationTitle(isEditCourse ? hostModel.viewModel.course.title : "Add Course")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "checkmark.circle.fill"))) {
                        hostModel.createCourse()
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
            courseView()
        }
        .padding()
    }
}

#Preview {
    CoursesView(hostModel: CoursesHostModel())
        .padding()
}
