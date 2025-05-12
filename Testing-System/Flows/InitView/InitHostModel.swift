//
//  InitHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class InitHostModel: BaseHostModel {
    @Published private(set) var viewModel: InitViewModel
    
    override init(backAction: BackNavigation? = nil) {
        self.viewModel = InitViewModel()
        super.init(backAction: backAction)
    }
    
}
