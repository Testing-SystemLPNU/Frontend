//
//  InitView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct LoginView: View {
    
    @StateObject var hostModel: LoginHostModel
    
    @ViewBuilder
    func loginView() -> some View {
        ZStack {
            VStack {
                NiceText("Login", style: .screenTitle)
                NiceTextField($hostModel.viewModel.userName,
                              contentType: .emailAddress,
                              placeholder: "Username")
                NiceTextField($hostModel.viewModel.password,
                              contentType: .emailAddress,
                              isSecure: true,
                              placeholder: "Password")
                
                NiceButton("Login",
                           style: .primary
                )
                {
                    hostModel.login()
                }
                
                NiceButton("Sign Up",
                           style: .borderless)
                {
                    hostModel.showSignUp()
                }
            }
            if hostModel.viewModel.showProgressView {
                ProgressView()
            }
        }
    }
    
    var body: some View {
        VStack {
            if hostModel.viewModel.isLoggedIn {
                Text("Logged")
            } else {
                if hostModel.viewModel.showSignup {
                    SignupView(hostModel: SignupHostModel(backAction: hostModel))
                } else {
                    loginView()
                        .disabled(hostModel.viewModel.showProgressView)
                        .onAppear {
                            print(#function)
                        }
                }
            }
        }
    }
}

#Preview {
    LoginView(hostModel: LoginHostModel())
}
