//
//  VerifyTicketView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents
import MijickCamera

struct Answer: Identifiable {
    var id: String
    var answer: String
    var correct: String
    var isCorrect: Bool {
        return answer == correct
    }
}

extension Dictionary where Value == String, Key == String {
    func createAnswers(correct: Self) -> [Answer] {
        let allKeys = Set(self.keys).union(correct.keys)
        return allKeys.compactMap { key in
            guard let correctAnswer = correct[key] else { return nil }
            let userAnswer = self[key] ?? "-"
            return Answer(id: key, answer: userAnswer, correct: correctAnswer)
        }
    }
}

public extension NiceTextStyle {
    static var bodyGreen: NiceTextStyle {
        var res = Config.current.bodyTextStyle
        res.color = .green
        return res
    }

    static var bodyRed: NiceTextStyle {
        var res = Config.current.bodyTextStyle
        res.color = .red
        return res
    }
}

struct VerifyTicketView: View {
    
    @StateObject var hostModel: VerifyTicketHostModel
    
    var answers: [Answer] {
        guard let results = hostModel.viewModel.results else {
            return []
        }
        return results.yourAnswers.createAnswers(correct: results.correctAnswers)
            .sorted { ans1, ans2 in
                Int(ans1.id) ?? 0 < Int(ans2.id) ?? 0
            }
    }
    
    @ViewBuilder
    func verifyView() -> some View {
        ZStack {
            NavigationView {
                let display = answers
                if let results = hostModel.viewModel.results,
                      !display.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            NiceText("Ticket:\(results.ticketNumber)", style: .sectionTitle)
                            NiceText("Student:\(results.studentFullName ?? "")", style: .itemTitle)
                            NiceText("Group:\(results.studentGroup ?? "")", style: .itemTitle)
                            
                            HStack {
                                NiceText("Score:", style: .itemTitle)
                                NiceText("\(results.score)/\(results.total)", style: .itemTitle)
                            }
                            .padding(.bottom, 8)
                            
                            Divider()
                            
                            ForEach(display) { answer in
                                HStack(spacing: 12) {
                                    NiceText("\(answer.id).", style: .body)
                                    NiceText(answer.answer, style: answer.isCorrect ? .bodyGreen : .bodyRed)
                                    if !answer.isCorrect {
                                        NiceText(answer.correct, style: .bodyGreen)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                    }
                } else {
                    NiceText("Loading...", style: .sectionTitle)
                }
            }
            .navigationTitle("Verify")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing:0) {
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                            hostModel.goBack()
                        }
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
            verifyView()
                .onAppear {
                }
                .fullScreenCover(isPresented: $hostModel.viewModel.showCameraView) {
                    MCamera()
                        .setCameraOutputType(.photo)
                        .setCloseMCameraAction { hostModel.goBack() }
                        .setAudioAvailability(false)
                        .setCameraPosition(.back)
                        .lockCameraInPortraitOrientation(AppDelegate.self)
                        .onImageCaptured { image, controller in
                            hostModel.process(image: image)
                        }
                        .startSession()
                }
        }
        .padding()
    }
}

