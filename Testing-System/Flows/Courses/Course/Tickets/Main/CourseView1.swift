////
////  ViewCourseView.swift
////  Testing-System
////
////  Created by Ihor Shevchuk on 5/4/25.
////
//
//import SwiftUI
//import NiceComponents
//import SwipeActions
//
//struct CourseView: View {
//    
//    @StateObject var hostModel: CourseHostModel
//    
//    @ViewBuilder
//    func questionItemView(_ question: Question)  -> some View {
//        SwipeView {
//                Button {
////                    hostModel.viewCourse(course)
//                } label: {
//                    HStack {
//                        Spacer()
//                        VStack {
//                            NiceText(question.questionText,
//                                     style: .itemTitle)
////                            NiceText(course.description,
////                                     style: .detail)
//                        }
//                        Spacer()
//                    }
//                }
//            .background(
//                RoundedRectangle(cornerRadius: 50, style: .continuous)
//                    .fill(Config.current.colorStyle.shadow)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 50, style: .continuous)
//                    .strokeBorder(Config.current.colorStyle.divider, lineWidth: 1)
//            )
//        } leadingActions: { _ in
//            SwipeAction {
////                hostModel.edit(course:course)
//            } label: { _ in
//                NiceImage(systemIcon:"pencil.and.scribble",
//                          tintColor: .white)
//            } background: { _ in
//                Config.current.colorStyle.primaryButton.surface
//            }
//        } trailingActions: { _ in
//            SwipeAction {
////                hostModel.delete(course:course)
//            } label: { _ in
//                NiceImage(systemIcon:"trash",
//                          tintColor: .white)
//            } background: { _ in
//                Config.current.colorStyle.destructiveButton.surface
//            }
//        }
//    }
//
//    @ViewBuilder
//    func courseView() -> some View {
//        ZStack {
//            NavigationView {
//                VStack {
//                    if hostModel.viewModel.questions.isEmpty {
//                        NiceText("No Questions! Create One Using '+' Button above!",
//                                 style: .itemTitle)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    } else {
//                        List(hostModel.viewModel.questions, id: \.id) { question in
//                            questionItemView(question)
//                        }
//                        .scrollContentBackground(.hidden)
//                        .background(Color.clear)
//                    }
//                }
//                .padding(.top, 15)
//            }
//            .navigationTitle(hostModel.viewModel.course.title)
//            .toolbarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
//                        hostModel.goBack()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "plus.circle.fill"))) {
////                        hostModel.addNewCourse()
//                    }
//                }
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "checkmark.circle.fill"))) {
////                        hostModel.createCourse()
////                    }
////                }
//            }
//            
//            if hostModel.viewModel.showProgressView {
//                ProgressView()
//            }
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            courseView()
//        }
//        .onAppear {
//            hostModel.loadQuestions()
//        }
//    }
//}
