//
//  InitView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI

struct InitView: View {
    
    @StateObject var hostModel: InitHostModel
    var body: some View {
        VStack {
            NavigationView {
                LoginView(hostModel: LoginHostModel())
            }
        }
    }
}

#Preview {
    InitView(hostModel: InitHostModel())
}
