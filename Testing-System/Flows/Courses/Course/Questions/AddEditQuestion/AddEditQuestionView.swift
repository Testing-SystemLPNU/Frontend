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

    @ViewBuilder
    func questionView() -> some View {
        ZStack {
            NavigationView {
                VStack(spacing: 12) {
                    
                    // QUESTION TEXT
                    NiceTextField(
                        $hostModel.viewModel.question.questionText,
                        placeholder: "Question"
                    )
                    
                    // OPTIONS
                    NiceTextField(
                        $hostModel.viewModel.question.optionA,
                        placeholder: "Option A"
                    )
                    NiceTextField(
                        $hostModel.viewModel.question.optionB,
                        placeholder: "Option B"
                    )
                    NiceTextField(
                        $hostModel.viewModel.question.optionC,
                        placeholder: "Option C"
                    )
                    NiceTextField(
                        $hostModel.viewModel.question.optionD,
                        placeholder: "Option D"
                    )
                    
                    // CORRECT OPTION PICKER
                    HStack {
                        NiceText("Correct Option", style: .itemTitle)
                        Spacer()
                        Picker(selection: $hostModel.viewModel.question.correctOption) {
                            ForEach(Question.Option.allCases) { option in
                                NiceText(option.rawValue, style: .itemTitle)
                            }
                        } label: {
                            NiceText("Correct Option", style: .itemTitle)
                        }
                        .niceText(.itemTitle)
                    }
                    // 🔥 DISPLAY GENERATION TYPE (READ ONLY)
                    if let type = hostModel.viewModel.question.questionGenerationType {
                        HStack {
                            NiceText("Generation Type", style: .itemTitle)
                            Spacer()
                            NiceText(displayName(for: type), style: .itemTitle)
                                .niceText(.itemTitle)
                        }
                        .padding(.top, 4)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(isEdit ? "Edit Question" : "Add Question")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                
                // CANCEL BUTTON
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton(
                        "",
                        style: .borderless,
                        rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))
                    ) {
                        hostModel.goBack()
                    }
                }
                
                // SAVE BUTTON
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton(
                        "",
                        style: .borderless,
                        rightImage: NiceButtonImage(NiceImage(systemIcon: "checkmark.circle.fill"))
                    ) {
                        hostModel.save()
                    }
                }
            }
            if hostModel.viewModel.showProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(4.0)
            }
        }
    }
    
    // 🔧 FUNCTION THAT CONVERTS API VALUE INTO UI TEXT
    func displayName(for type: String) -> String {
        switch type.uppercased() {
        case "BLOOM":
            return "blom"
        case "AI":
            return "AI"
        case "MANUAL":
            return "Manual"
        default:
            return type.lowercased()
        }
    }

    var body: some View {
        VStack {
            questionView()
        }
        .padding()
    }
}

