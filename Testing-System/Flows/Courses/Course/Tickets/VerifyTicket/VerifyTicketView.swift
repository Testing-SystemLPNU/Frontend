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
        let size = Swift.min(count, correct.count)
        let keys = Array(self.keys)
        return (0..<size).compactMap {
            guard let answer = self[keys[$0]],
                  let correctAnswer = correct[keys[$0]] else {
                return nil
            }
            return Answer(id:keys[$0], answer: answer, correct: correctAnswer)
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
        return results.yourAnswers.createAnswers(correct: results.yourAnswers)
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
                        NiceText("Ticket:\(results.ticketNumber)", style: .sectionTitle)
                        NiceText("Student:\(results.studentFullName ?? "")", style: .itemTitle)
                        NiceText("Group:\(results.studentGroup ?? "")", style: .itemTitle)
                        
                        HStack {
                            NiceText("Score:", style: .itemTitle)
                            NiceText("\(results.score)/\(results.total)", style: .itemTitle)
                        }
                        .padding()
                        ForEach(display) { answer in
                            HStack {
                                NiceText("\(answer.id).", style: .body)
                                NiceText("\(answer.answer)", style: .body)
                                NiceText("\(answer.correct)", style: answer.isCorrect ? .bodyGreen : .bodyRed)
                                Spacer()
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
