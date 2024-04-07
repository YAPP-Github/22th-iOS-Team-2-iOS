//
//  AccountSettingBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs

protocol AccountSettingDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AccountSettingComponent: Component<AccountSettingDependency>,
                                     LogoutPopupDependency,
                                     CommonWebDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AccountSettingBuildable: Buildable {
    func build(withListener listener: AccountSettingListener) -> AccountSettingRouting
}

final class AccountSettingBuilder: Builder<AccountSettingDependency>, AccountSettingBuildable {

    override init(dependency: AccountSettingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountSettingListener) -> AccountSettingRouting {
        let component = AccountSettingComponent(dependency: dependency)
        let viewController = AccountSettingViewController()
        let interactor = AccountSettingInteractor(presenter: viewController)
        interactor.listener = listener
        let logoutPopupBuilder = LogoutPopupBuilder(dependency: component)
        let commonWebBuilder = CommonWebBuilder(dependency: component)
        
        return AccountSettingRouter(
            interactor: interactor,
            viewController: viewController,
            logoutPopupBuilder: logoutPopupBuilder,
            commonWebBuilderable: commonWebBuilder
        )
    }
}
