//
//  InitView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI

struct InitView: View {
    
    @StateObject var hostModel: InitHostModel
    
    @ViewBuilder
    func loadingIndicator() -> some View {
        VStack {
            ProgressView()
            Text("Loading...")
        }
        .padding()
    }
    
    var body: some View {
        VStack {
            if let isLoggedIn = hostModel.viewModel.isLoggedIn {
                NavigationView {
                    if isLoggedIn {
                        Text("Logged in")
                    } else {
                        LoginView(hostModel: LoginHostModel())
                    }
                }
                
            } else {
                loadingIndicator()
            }
        }
        .onAppear {
            hostModel.checkToken()
        }
    }
}

#Preview {
    InitView(hostModel: InitHostModel())
}
