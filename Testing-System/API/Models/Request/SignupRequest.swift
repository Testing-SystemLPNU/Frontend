//
//  SignupRequest.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/11/25.
//

struct SignupRequest: Encodable {
    let email: String
    let password: String
    let confirmPassword: String
    let fullName: String
}
