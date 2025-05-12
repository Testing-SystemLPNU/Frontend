//
//  CoursesView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents
import SwipeActions

struct CoursesView: View {
    
    @StateObject var hostModel: CoursesHostModel
    
    @ViewBuilder
    func courseItemView(_ course: Course)  -> some View {
        SwipeView {
            VStack {
                NiceText(course.title,
                         style: .itemTitle)
                NiceText(course.description,
                         style: .detail)
                NiceDivider()
            }
        } leadingActions: { _ in
            SwipeAction {
                hostModel.edit(course:course)
            } label: { _ in
                NiceImage(systemIcon:"pencil.and.scribble",
                          tintColor: .white)
            } background: { _ in
                Config.current.colorStyle.primaryButton.surface
            }
        } trailingActions: { _ in
            SwipeAction {
                hostModel.delete(course:course)
            } label: { _ in
                NiceImage(systemIcon:"trash",
                          tintColor: .white)
            } background: { _ in
                Config.current.colorStyle.destructiveButton.surface
            }
        }
    }
    
    @ViewBuilder
    func addEditCourseView(_ course: Course)  -> some View {
        Text(course.title)
    }

    @ViewBuilder
    func coursesView() -> some View {
        ZStack {
            NavigationView {
                if hostModel.viewModel.courses.isEmpty {
                    NiceText("No Courses! Create One Using '+' Button above!",
                             style: .itemTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    List(hostModel.viewModel.courses, id: \.id) { course in
                        courseItemView(course)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("Available Courses")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "plus.circle.fill"))) {
                        hostModel.addNewCourse()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "gearshape.circle.fill"))) {
                        hostModel.showSettings()
                    }
                }
            }
            
            if hostModel.viewModel.showProgressView {
                ProgressView()
            }
        }
        .onAppear {
            hostModel.loadCourses()
        }
    }
    
    var body: some View {
        VStack {
            if let courseToEdit = hostModel.viewModel.courseToEditAdd {
                AddEditCourseView(hostModel: AddEditCourseHostModel(course: courseToEdit, backAction: hostModel))
            } else {
                coursesView()
            }
        }
    }
}

#Preview {
    CoursesView(hostModel: CoursesHostModel())
        .padding()
}
