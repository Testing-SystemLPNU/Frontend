//
//  VerifyTicketHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation
import UIKit
import Vision

class GroupResultsHostModel: BaseHostModel {
    @Published var viewModel: GroupResultsViewModel
    
    init(course: Course, backAction: BackNavigation) {
        self.viewModel = GroupResultsViewModel(course:course)
        super.init(backAction: backAction)
    }
    
    func checkGroup(name: String) {
        if name.isEmpty {
            return
        }
        viewModel.showProgressView = true
        publishUpdate()
    }
    
    func checkAnotherGroup() {
        viewModel.results.removeAll()
        publishUpdate()
    }
    
    func doCheckTicket(name: String)  async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            viewModel.results = try await AppManager.shared.apiConnector.getGroupResults(name: name)
        } catch {
            print("Get group result error: \(error)")
        }
    }
    
    func sharePDF() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doSharePDF()
        }
    }
    
    private func doSharePDF() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            
            let pdfData = try await AppManager.shared.apiConnector.pdfGroupResults(name: viewModel.groupName)
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "\(viewModel.groupName).pdf"
            let fileURL = tempDir.appendingPathComponent(fileName)
            try pdfData.write(to: fileURL)
            viewModel.pdfURL = fileURL
        } catch {
            print("Load PDF error: \(error)")
        }
    }
    
}
