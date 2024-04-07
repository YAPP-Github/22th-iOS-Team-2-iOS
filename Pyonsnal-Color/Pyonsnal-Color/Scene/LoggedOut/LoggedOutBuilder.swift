//
//  LoggedOutBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import ModernRIBs

protocol LoggedOutDependency: Dependency {
    var appleLoginService: AppleLoginService { get }
    var kakaoLoginService: KakaoLoginService { get }
    var authClient: AuthAPIService { get }
    var userAuthService: UserAuthService { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency>,
                                TermsOfUseDependency {

}

// MARK: - Builder
protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component: LoggedOutComponent = .init(dependency: dependency)
        let viewController: LoggedOutViewController = .init()
        let termsOfUseBuilder = TermsOfUseBuilder(dependency: component)
        
        let interactor: LoggedOutInteractor = .init(
            presenter: viewController,
            dependency: dependency
        )
        interactor.listener = listener

        let router: LoggedOutRouter = .init(
            interactor: interactor,
            viewController: viewController,
            termsOfUseBuilder: termsOfUseBuilder
        )
        return router
    }
}
