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
                NiceTextField($hostModel.viewModel.username,
                              contentType: .emailAddress,
                              placeholder: "Username")
                NiceTextField($hostModel.viewModel.password,
                              contentType: .password,
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
                    withAnimation {
                        hostModel.showSignUp()
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
            if hostModel.viewModel.isLoggedIn {
                CoursesView(hostModel: CoursesHostModel(backAction: hostModel))
            } else {
                if hostModel.viewModel.showSignup {
                    SignupView(hostModel: SignupHostModel(backAction: hostModel))
                } else {
                    loginView()
                        .disabled(hostModel.viewModel.showProgressView)
                        .onAppear {
                            hostModel.checkLogin()
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(hostModel: LoginHostModel())
}
