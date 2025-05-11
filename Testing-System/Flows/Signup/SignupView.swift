//
//  SignupView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct SignupView: View {
    
    @StateObject var hostModel: SignupHostModel
    
    @ViewBuilder
    func signupView() -> some View {
        ZStack {
            VStack {
                Spacer()
                NiceText("Sign Up", style: .screenTitle)
                NiceTextField($hostModel.viewModel.fullname,
                              contentType: .name,
                              placeholder: "Full Name")
                NiceTextField($hostModel.viewModel.email,
                              contentType: .emailAddress,
                              placeholder: "Email")
                NiceTextField($hostModel.viewModel.password,
                              contentType: .password,
                              isSecure: true,
                              placeholder: "Password")
                NiceTextField($hostModel.viewModel.confirmPassword,
                              contentType: .password,
                              isSecure: true,
                              placeholder: "Confirm Password")
                NiceButton("Sign Up",
                           style: .primary)
                {
                    hostModel.signup()
                }
                NiceButton("Already have an account? Login",
                           style: .borderless)
                {
                    withAnimation {
                        hostModel.goBack()
                    }
                }
                Spacer()
            }
            if hostModel.viewModel.showProgressView {
                ProgressView()
            }
        }
    }
    
    var body: some View {
        VStack {
            signupView()
        }
    }
}

#Preview {
    SignupView(hostModel: SignupHostModel())
        .padding()
}
