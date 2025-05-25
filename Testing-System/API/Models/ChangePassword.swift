//
//  ChangePassword.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/24/25.
//

struct ChangePassword: Encodable {
    var oldPassword: String
    var newPassword: String
    var confirmNewPassword: String
}
