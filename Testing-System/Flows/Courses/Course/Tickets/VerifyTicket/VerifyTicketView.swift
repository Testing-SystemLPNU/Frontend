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



struct VerifyTicketView: View {
    
    @StateObject var hostModel: VerifyTicketHostModel
    
    var answers: [Answer] {
        guard let results = hostModel.viewModel.results else {
            return []
        }
        return results.yourAnswers.createAnswers(correct: results.yourAnswers)
    }
    
    @ViewBuilder
    func verifyView() -> some View {
        ZStack {
            NavigationView {
                let display = answers
                if let results = hostModel.viewModel.results,
                      display.isEmpty {
                    VStack {
                        NiceText("Score:", style: .sectionTitle)
                        NiceText("\(results.scrore)/\(results.total)", style: .sectionTitle)
                        ForEach(display) { answer in
                            NiceText("\(answer.id). \(answer.answer) - \(answer.isCorrect ? "✅" : "❌")", style: .sectionTitle)
                        }
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
