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
            VStack(alignment: .leading, spacing: 12) {
                NiceText("Results for group: \(hostModel.viewModel.groupName)", style: .sectionTitle)
                    .padding(.bottom, 4)
                
                // Заголовок таблиці
                HStack {
                    Text("Student").bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("Ticket").bold().frame(width: 60, alignment: .center)
                    Text("Score").bold().frame(width: 60, alignment: .center)
                    Text("Max Score").bold().frame(width: 80, alignment: .center)
                }
                .foregroundColor(.gray)
                .padding(.bottom, 4)
                
                Divider()
                
                // Рядки таблиці
                ForEach(hostModel.viewModel.results, id: \.self.ticketId) { result in
                    HStack {
                        Text(result.studentName).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(result.ticketId)").frame(width: 60, alignment: .center)
                        Text("\(result.score)").frame(width: 60, alignment: .center)
                        Text("\(result.maxScore)").frame(width: 80, alignment: .center)
                    }
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                NiceButton("Check Another Group", style: .primary) {
                    hostModel.checkAnotherGroup()
                }
                .padding(.top)
            }
            .padding()
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
