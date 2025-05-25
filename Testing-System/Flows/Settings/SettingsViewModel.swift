//
//  SettingsViewModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

class SettingsViewModel {
    var showProgressView: Bool = true
    var changePasswordMode : Bool = false
    var userInfo: UserInfo? = nil
    var changePassoword = ChangePassword(oldPassword: "", newPassword: "", confirmNewPassword: "")
}
