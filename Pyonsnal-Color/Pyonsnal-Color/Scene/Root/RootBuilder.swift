//
//  RootBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/29.
//

import ModernRIBs

protocol RootDependency: Dependency {
    var userAuthService: UserAuthService { get }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let component: RootComponent = .init(
            rootViewController: viewController,
            dependency: dependency
        )
        let interactor: RootInteractor = .init(presenter: viewController, dependency: dependency)
        let loggedOutBuilder: LoggedOutBuilder = .init(dependency: component)
        let loggedInBuilder: LoggedInBuilder = .init(dependency: component)
        let router: RootRouter = .init(
            interactor: interactor,
            viewController: viewController,
            loggedOutBuilder: loggedOutBuilder,
            loggedInBuilder: loggedInBuilder
        )

        return router
    }
}
