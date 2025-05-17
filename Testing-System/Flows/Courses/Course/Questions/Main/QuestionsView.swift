//
//  QuestionsView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents
import SwipeActions
import UniformTypeIdentifiers

struct QuestionsView: View {
    
    @StateObject var hostModel: QuestionsHostModel
    
    @ViewBuilder
    func questionItemView(_ question: Question)  -> some View {
        SwipeView {
                Button {
                    hostModel.edit(question: question)
                } label: {
                    HStack {
                        Spacer()
                        VStack {
                            NiceText(question.questionText,
                                     style: .itemTitle)
                        }
                        Spacer()
                    }
                    .frame(minHeight:40)
                }
            .background(
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .fill(Config.current.colorStyle.shadow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .strokeBorder(Config.current.colorStyle.divider, lineWidth: 1)
            )
        } trailingActions: { _ in
            SwipeAction {
                hostModel.delete(question: question)
            } label: { _ in
                NiceImage(systemIcon:"trash",
                          tintColor: .white)
            } background: { _ in
                Config.current.colorStyle.destructiveButton.surface
            }
        }
    }

    @ViewBuilder
    func courseView() -> some View {
        ZStack {
            NavigationView {
                VStack {
                    if hostModel.viewModel.questions.isEmpty {
                        NiceText("No Questions! Create One Using '+' Button above!",
                                 style: .itemTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                    } else {
                        List(hostModel.viewModel.questions, id: \.id) { question in
                            questionItemView(question)
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                .padding(.top, 15)
            }
            .navigationTitle("Questions")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 0.0) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "apple.intelligence"))) {
                        hostModel.showFileImport()
                    }
                    
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "plus.circle.fill"))) {
                        hostModel.addNewQuestion()
                    }
                    }
                }
            }
            .fileImporter(isPresented: $hostModel.viewModel.presentImportFile, allowedContentTypes: [
                UTType("org.openxmlformats.wordprocessingml.document")!
            ]) { result in
                switch result {
                case .success(let file):
                    hostModel.generateQuestionsFromFile(at: file)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            if hostModel.viewModel.showProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(4.0)
            }
        }
    }
    
    var body: some View {
        VStack {
            if let question = hostModel.viewModel.questionToEditAdd {
                AddEditQuestionView(hostModel: AddEditQuestionHostModel(course: hostModel.viewModel.course, question: question, backAction: hostModel))
            } else {
                courseView()
                    .onAppear {
                        hostModel.loadQuestions()
                    }
            }
        }
    }
}
