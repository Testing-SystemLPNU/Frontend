//
//  AddEditTicketView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct AddEditTicketView: View {
    
    @StateObject var hostModel: AddEditTicketHostModel
    
    var isEdit: Bool {
        return hostModel.viewModel.ticket.id != nil
    }
    
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }
    
    @ViewBuilder
    func questionSelectionItem(question: Question) -> some View {
        let isSelected = hostModel.isSelected(question: question)
        let image = NiceImage(systemIcon: isSelected ? "checkmark.circle.fill" : "circle",
                              width: 16,
                              height: 16)
        Button {
            if isSelected {
                hostModel.deselect(question: question)
            } else {
                hostModel.select(question: question)
            }
        } label: {
            HStack {
                image
                    .padding(.leading, 8)
                NiceText(question.questionText, style: .itemTitle)
                Spacer()
            }
        }
    }


    @State private var selectedFlavor: Flavor = .chocolate

    @ViewBuilder
    func ticketView() -> some View {
        ZStack {
            NavigationView {
                ScrollView {
                    NiceTextField($hostModel.viewModel.ticket.studentGroup,
                                  placeholder: "Group")
                    NiceTextField($hostModel.viewModel.ticket.studentFullName,
                                  placeholder: "Student Full Name")
                    ForEach(hostModel.viewModel.questions, id: \.id) { question in
                        questionSelectionItem(question: question)
                    }
                }
            }
            .navigationTitle(isEdit ? "Ticket": "Add Ticket")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing:0) {
                        
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                            hostModel.goBack()
                        }
                        
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "square.and.arrow.up.circle"))) {
                            hostModel.sharePDF()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing:0) {
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "checkmark.arrow.trianglehead.counterclockwise"))) {
                            //                        hostModel.addNewTicket()
                        }
                        
                        NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "checkmark.circle.fill"))) {
                            hostModel.save()
                        }
                        .disabled(hostModel.viewModel.ticket.questionIds.isEmpty)
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
                ticketView()
                    .onAppear {
                        hostModel.loadQuestions()
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
        }
        .padding()
    }
}
