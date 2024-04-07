//
//  RootTabBarComponent.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

final class RootTabBarComponent: Component<RootTabBarDependency> {
}

extension RootTabBarComponent: ProductHomeDependency,
                               EventHomeDependency,
                               FavoriteHomeDependency,
                               ProfileHomeDependency {

    var client: PyonsnalColorClient {
        return PyonsnalColorClient()
    }
    var userAuthService: UserAuthService {
        return UserAuthService(keyChainService: KeyChainService.shared)
    }
    
    var favoriteAPIService: FavoriteAPIService {
        return FavoriteAPIService(client: client, userAuthService: userAuthService)
    }
    
    var productAPIService: ProductAPIService {
        return ProductAPIService(client: client, userAuthService: userAuthService)
    }
    
}
