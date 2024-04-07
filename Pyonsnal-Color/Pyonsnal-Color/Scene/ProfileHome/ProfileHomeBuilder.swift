//
//  ProfileHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProfileHomeDependency: Dependency {
}

final class ProfileHomeComponent: Component<ProfileHomeDependency>,
                                  ProfileEditDependency,
                                  AccountSettingDependency,
                                  CommonWebDependency,
                                  LoggedOutDependency {
    var appleLoginService: AppleLoginService
    var kakaoLoginService: KakaoLoginService
    var authClient: AuthAPIService
    var userAuthService: UserAuthService
    var memberAPIService: MemberAPIService
    
    override init(dependency: ProfileHomeDependency) {
        let pyonsnalColorClient = PyonsnalColorClient()
        let keyChainService = KeyChainService.shared
        let usetAuthService = UserAuthService(keyChainService: keyChainService)
        self.appleLoginService = AppleLoginService()
        self.kakaoLoginService = KakaoLoginService()
        self.authClient = .init(client: pyonsnalColorClient)
        self.userAuthService = usetAuthService
        self.memberAPIService = .init(client: pyonsnalColorClient,
                                      userAuthService: usetAuthService)
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder

protocol ProfileHomeBuildable: Buildable {
    func build(withListener listener: ProfileHomeListener) -> ProfileHomeRouting
}

final class ProfileHomeBuilder: Builder<ProfileHomeDependency>,
                                ProfileHomeBuildable {

    override init(dependency: ProfileHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileHomeListener) -> ProfileHomeRouting {
        let component = ProfileHomeComponent(dependency: dependency)
        let viewController = ProfileHomeViewController()
        let interactor = ProfileHomeInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        let profileEditBuilder = ProfileEditBuilder(dependency: component)
        let accountSettingBuilder = AccountSettingBuilder(dependency: component)
        let commonWebBuilder = CommonWebBuilder(dependency: component)
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        
        return ProfileHomeRouter(
            interactor: interactor,
            viewController: viewController, 
            profileEditBuilder: profileEditBuilder,
            accountSettingBuilder: accountSettingBuilder,
            commonWebBuilder: commonWebBuilder,
            loggedOutBuilder: loggedOutBuilder
        )
    }
}
