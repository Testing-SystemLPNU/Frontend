//
//  AddEditQuestionView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct AddEditQuestionView: View {
    
    @StateObject var hostModel: AddEditQuestionHostModel
    
    var isEdit: Bool {
        return hostModel.viewModel.question.id != nil
    }
    
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }


    @State private var selectedFlavor: Flavor = .chocolate

    @ViewBuilder
    func questionView() -> some View {
        ZStack {
            NavigationView {
                VStack {
                    NiceTextField($hostModel.viewModel.question.questionText,
                                  placeholder: "Question")
                    NiceTextField($hostModel.viewModel.question.optionA,
                                  placeholder: "Option A")
                    NiceTextField($hostModel.viewModel.question.optionB,
                                  placeholder: "Option B")
                    NiceTextField($hostModel.viewModel.question.optionC,
                                  placeholder: "Option C")
                    NiceTextField($hostModel.viewModel.question.optionD,
                                  placeholder: "Option D")
                    HStack {
                        NiceText("Correct Option", style: .itemTitle)
                        Spacer()
                        Picker(selection: $hostModel.viewModel.question.correctOption) {
                            ForEach(Question.Option.allCases) { option in
                                NiceText(option.rawValue, style: .itemTitle)
                            }
                        }
                        label: {
                            NiceText("Correct Option", style: .itemTitle)
                        }
                        .niceText(.itemTitle)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(isEdit ? "Edit Question": "Add Question")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "checkmark.circle.fill"))) {
                        hostModel.save()
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
            questionView()
        }
        .padding()
    }
}
