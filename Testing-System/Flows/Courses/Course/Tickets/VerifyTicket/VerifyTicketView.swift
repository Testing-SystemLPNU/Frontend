//
//  VerifyTicketView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents
import MijickCamera

struct VerifyTicketView: View {
    
    @StateObject var hostModel: VerifyTicketHostModel
    
    @ViewBuilder
    func verifyView() -> some View {
        ZStack {
            NavigationView {
                Text("Hello")
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "square.and.arrow.up.circle"))) {
                        //                                                hostModel.sharePDF()
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
                        .onImageCaptured { image, controller in
                            hostModel.process(image: image)
                        }
                        .startSession()
                }
        }
        .padding()
    }
}
