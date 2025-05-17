//
//  TicketsView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents
import SwipeActions

struct TicketsView: View {
    
    @StateObject var hostModel: TicketsHostModel
    
    @ViewBuilder
    func ticketItemView(_ ticket: Ticket)  -> some View {
        SwipeView {
                Button {
                    hostModel.edit(ticket:ticket)
                } label: {
                    HStack {
                        Spacer()
                        VStack {
                            NiceText("\(ticket.studentGroup): \(ticket.studentFullName)",
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
                hostModel.delete(ticket:ticket)
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
                    if hostModel.viewModel.tickets.isEmpty {
                        NiceText("No Tickets! Create One Using '+' Button above!",
                                 style: .itemTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                    } else {
                        List(hostModel.viewModel.tickets, id: \.id) { ticket in
                            ticketItemView(ticket)
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                .padding(.top, 15)
            }
            .navigationTitle("Tickets:\(hostModel.viewModel.course.title)")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "plus.circle.fill"))) {
                        hostModel.addNewTicket()
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
            if let ticket = hostModel.viewModel.ticketToEditAdd {
                AddEditTicketView(hostModel: AddEditTicketHostModel(course: hostModel.viewModel.course, ticket: ticket, backAction: hostModel))
            } else {
                courseView()
                    .onAppear {
                        hostModel.loadTickets()
                    }
            }
        }
    }
}
