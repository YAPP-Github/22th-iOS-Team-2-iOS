//
//  ProfileHomeBuilder_R.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import Foundation

struct ProfileHomeBuilder_R {
    private let dependency: ProfileHomeViewModel.Dependency
    
    init(dependency: ProfileHomeViewModel.Dependency) {
        self.dependency = dependency
    }
    
    func build(payload: ProfileHomeViewModel.Payload) -> ProfileHomeViewController_R {
        let router = ProfileHomeRouter_R()
        let viewModel = ProfileHomeViewModel(
            dependency: dependency,
            payload: payload,
            router: router
        )
        let viewController = ProfileHomeViewController_R(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
