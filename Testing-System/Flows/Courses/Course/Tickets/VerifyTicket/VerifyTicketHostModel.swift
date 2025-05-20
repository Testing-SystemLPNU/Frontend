//
//  VerifyTicketHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation
import UIKit
import Vision

class VerifyTicketHostModel: BaseHostModel {
    @Published var viewModel: VerifyTicketViewModel
    
    init(course: Course, ticket: Ticket, backAction: BackNavigation) {
        self.viewModel = VerifyTicketViewModel(course:course, ticket: ticket)
        super.init(backAction: backAction)
    }
    
    
    func process(image: UIImage) {
        toggleCamera()
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doCheckTicket(image: image)
        }
    }
    
    func doCheckTicket(image: UIImage)  async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            viewModel.results = try await AppManager.shared.apiConnector.check(ticket: viewModel.ticket, image: image, for: viewModel.course)
        } catch {
            print("Check ticket error: \(error)")
        }
    }
    
    func toggleCamera() {
        viewModel.showCameraView.toggle()
        publishUpdate()
    }
}
