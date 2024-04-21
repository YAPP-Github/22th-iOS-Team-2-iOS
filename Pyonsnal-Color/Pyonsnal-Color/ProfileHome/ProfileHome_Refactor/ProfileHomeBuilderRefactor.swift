//
//  ProfileHomeBuilder_R.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import Foundation

struct ProfileHomeBuilderRefactor {
    private let dependency: ProfileHomeViewModel.Dependency
    
    init(dependency: ProfileHomeViewModel.Dependency) {
        self.dependency = dependency
    }
    
    func build(payload: ProfileHomeViewModel.Payload) -> ProfileHomeViewControllerRefactor {
        let router = ProfileHomeRouterRefactor()
        let viewModel = ProfileHomeViewModel(
            dependency: dependency,
            payload: payload,
            router: router
        )
        let viewController = ProfileHomeViewControllerRefactor(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
