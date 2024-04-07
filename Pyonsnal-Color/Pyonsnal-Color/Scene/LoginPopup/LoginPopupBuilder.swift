//
//  LoginPopupBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import ModernRIBs

protocol LoginPopupDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class LoginPopupComponent: Component<LoginPopupDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LoginPopupBuildable: Buildable {
    func build(withListener listener: LoginPopupListener) -> LoginPopupRouting
}

final class LoginPopupBuilder: Builder<LoginPopupDependency>, LoginPopupBuildable {

    override init(dependency: LoginPopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoginPopupListener) -> LoginPopupRouting {
        let component = LoginPopupComponent(dependency: dependency)
        let viewController = LoginPopupViewController()
        let interactor = LoginPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return LoginPopupRouter(interactor: interactor, viewController: viewController)
    }
}
