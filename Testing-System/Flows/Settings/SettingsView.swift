//
//  ViewCourseView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct SettingsView: View {
    
    @StateObject var hostModel: SettingsHostModel
    
    @ViewBuilder
    func settingsView(user: UserInfo) -> some View {
        ZStack {
            NavigationView {
                VStack {
                    NiceText("Name: \(user.fullName)", style: .sectionTitle)
                     
                    NiceText("Email: \(user.email)", style: .sectionTitle)
                    
                    NiceButton("Change Password", style: .primary) {
                        hostModel.changePassword()
                    }
                    .padding()
                    NiceButton("Logout", style: .primary) {
                        hostModel.logout()
                    }
                    .padding()
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                        hostModel.goBack()
                    }
                }
            }
            
            if hostModel.viewModel.showProgressView {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    func changePassword() -> some View {
        NavigationView {
            VStack {
                NiceTextField($hostModel.viewModel.changePassoword.oldPassword,
                              placeholder: "Old Password")
                NiceTextField($hostModel.viewModel.changePassoword.newPassword,
                              placeholder: "New Password")
                NiceTextField($hostModel.viewModel.changePassoword.confirmNewPassword,
                              placeholder: "Confirm New Password")
                
                NiceButton("Change Password", style: .primary) {
                    hostModel.changePassword()
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Change Password")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "xmark.circle.fill"))) {
                    hostModel.closeChangePasswordMode()
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if hostModel.viewModel.showProgressView {
                ProgressView()
                    .onAppear {
                        hostModel.loadUserData()
                    }
            } else {
                if hostModel.viewModel.changePasswordMode {
                    changePassword()
                } else if let userInfo = hostModel.viewModel.userInfo {
                    settingsView(user: userInfo)
                }
            }
        }
    }
}
