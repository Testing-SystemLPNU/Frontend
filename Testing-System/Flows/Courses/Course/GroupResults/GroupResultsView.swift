//
//  VerifyTicketView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct GroupResultsView: View {
    
    @StateObject var hostModel: GroupResultsHostModel
    
    @ViewBuilder
    func requestView() -> some View {
        VStack {
            NiceTextField($hostModel.viewModel.groupName, placeholder: "Group name")
            NiceButton("Check", style: .primary) {
                hostModel.checkGroup(name: hostModel.viewModel.groupName)
            }
        }
    }
    
    func resultsView() -> some View {
        VStack {
            NiceText("Results:", style: .sectionTitle)
            ForEach(hostModel.viewModel.results, id: \.self.ticketId) { result in
                NiceText("\(result.ticketId). \(result.studentName) - \(result.score)", style: .body)
            }
            
            NiceButton("Check", style: .primary) {
                hostModel.checkAnotherGroup()
            }
        }
    }
    
    @ViewBuilder
    func groupResultsView() -> some View {
        ZStack {
            NavigationView {
                if hostModel.viewModel.results.isEmpty {
                    requestView()
                } else {
                    resultsView()
                }
            }
            .navigationTitle("Group Results")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing:0) {
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                            hostModel.goBack()
                        }
                    }
                }
                
                if !hostModel.viewModel.results.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "square.and.arrow.up.circle"))) {
                            hostModel.sharePDF()
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
            groupResultsView()
        }
        .sheet(isPresented: .init(get: {
            return hostModel.viewModel.pdfURL != nil
        }, set: { show in
            if !show {
                hostModel.viewModel.pdfURL = nil
            }
        })) {
            if let url = hostModel.viewModel.pdfURL {
                ShareSheet(activityItems: [url])
            }
        }
        .padding()
    }
}
