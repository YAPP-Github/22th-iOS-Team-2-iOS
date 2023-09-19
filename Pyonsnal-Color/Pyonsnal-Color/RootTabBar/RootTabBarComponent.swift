//
//  RootTabBarComponent.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

final class RootTabBarComponent: Component<RootTabBarDependency> {
}

extension RootTabBarComponent: ProductHomeDependency, EventHomeDependency, ProfileHomeDependency {
    
    var userAuthService: UserAuthService {
        return UserAuthService(keyChainService: KeyChainService.shared)
    }
    var productAPIService: ProductAPIService {
        return ProductAPIService(client: PyonsnalColorClient(), userAuthService: userAuthService)
    }
    
}
