//
//  AddEditQuestionView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents
import UniformTypeIdentifiers

struct BloomGenerationView: View {
    
    @StateObject var hostModel: BloomGenerationHostModel

    @ViewBuilder
    func contentView() -> some View {
        ZStack {
            NavigationView {
                VStack {
                    let title = if let title = hostModel.viewModel.selectedFile?.lastPathComponent {
                        "Replace file: \(title)"
                    } else {
                        "Upload File"
                    }
                    
                    
                    NiceButton(title, style: .primary) {
                        hostModel.showFileImport()
                    }
                    
                    HStack {
                        NiceText("Level: ", style: .itemTitle)
                        Spacer()
                        Picker(selection: $hostModel.viewModel.selectedLevel) {
                            ForEach(BloomGenerationLevel.allCases) { option in
                                NiceText(option.stringValue, style: .itemTitle)
                            }
                        }
                        label: {
                            NiceText("Choose the Level", style: .itemTitle)
                        }
                        .niceText(.itemTitle)
                    }
                    
                    Spacer()
                    
                    NiceButton("Generate questions", style: .primary) {
                        hostModel.generate()
                    }
                }
            }
            .navigationTitle("Bloom Generation")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
            }
            .fileImporter(isPresented: $hostModel.viewModel.presentImportFile, allowedContentTypes: [
                UTType("org.openxmlformats.wordprocessingml.document")!
            ]) { result in
                switch result {
                case .success(let file):
                    hostModel.viewModel.selectedFile = file
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            if hostModel.viewModel.showProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(4.0)
            }
        }
    }
    
    var body: some View {
        VStack {
            contentView()
        }
        .padding()
    }
}
