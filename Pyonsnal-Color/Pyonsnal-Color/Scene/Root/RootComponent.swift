//
//  RootComponent.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootDependencyLoggedOut: Dependency {
}

final class RootComponent: Component<RootDependency> {
    
    let rootViewController: RootViewController
    var appleLoginService: AppleLoginService
    var kakaoLoginService: KakaoLoginService
    let userAuthService: UserAuthService
    var authClient: AuthAPIService
    
    init(rootViewController: RootViewController,
         dependency: RootDependency
    ) {
        self.rootViewController = rootViewController
        self.appleLoginService = AppleLoginService()
        self.kakaoLoginService = KakaoLoginService()
        let keyChainService = KeyChainService.shared
        self.userAuthService = .init(keyChainService: keyChainService)
        let pyonsnalColorClient = PyonsnalColorClient()
        self.authClient = .init(client: pyonsnalColorClient)
        super.init(dependency: dependency)
    }
}

extension RootComponent: LoggedOutDependency {
}

extension RootComponent: LoggedInDependency {
    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
}
