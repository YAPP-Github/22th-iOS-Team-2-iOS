//
//  RootTabBarBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootTabBarDependency: Dependency {
}

// MARK: - Builder

protocol RootTabBarBuildable: Buildable {
    func build(withListener listener: RootTabBarListener) -> RootTabBarRouting
}

final class RootTabBarBuilder: Builder<RootTabBarDependency>, RootTabBarBuildable {
    
    override init(dependency: RootTabBarDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: RootTabBarListener) -> RootTabBarRouting {
        let component: RootTabBarComponent = .init(dependency: dependency)
        let tabBarController = RootTabBarViewController()
        let interactor: RootTabBarInteractor = .init(presenter: tabBarController)
        
        let productHomeBuilder: ProductHomeBuilder = .init(dependency: component)
        let eventHomeBuilder: EventHomeBuilder = .init(dependency: component)
        let favoriteHomeBuilder: FavoriteHomeBuilder = .init(dependency: component)
        let profileHomeBuilder: ProfileHomeBuilder = .init(dependency: component)
        
        interactor.listener = listener
        
        let router = RootTabBarRouter(
            interactor: interactor,
            viewController: tabBarController,
            productHomeBuilder: productHomeBuilder,
            eventHomeBuilder: eventHomeBuilder,
            favoriteHomeBuilder: favoriteHomeBuilder,
            profileHomeBuilder: profileHomeBuilder
        )
        
        return router
    }
}
