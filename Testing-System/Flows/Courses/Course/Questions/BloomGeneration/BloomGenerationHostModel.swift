//
//  BloomGenerationHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 11/27/25.
//

import Foundation

class BloomGenerationHostModel: BaseHostModel {
    @Published var viewModel: BloomGenerationViewModel
    
    init(course: Course, backAction: BackNavigation) {
        self.viewModel = BloomGenerationViewModel(course:course)
        super.init(backAction: backAction)
    }
    
    func showFileImport() {
        viewModel.presentImportFile = true
        publishUpdate()
    }
    
    func generate() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doGenerate()
        }
    }
    
    private func doGenerate() async {

        guard let file = viewModel.selectedFile else { return }

        let access = file.startAccessingSecurityScopedResource()
        defer {
            if access {
                file.stopAccessingSecurityScopedResource()
            }
        }

        do {
            try await AppManager.shared.apiConnector.generateBloomQuestions(
                from: file,
                for: viewModel.course,
                and: viewModel.selectedLevel
            )
        } catch {
            print("❌ Create question error:", error)
        }
    }
}
