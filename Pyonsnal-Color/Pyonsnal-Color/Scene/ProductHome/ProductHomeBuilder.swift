//
//  ProductHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeDependency: Dependency {
    var productAPIService: ProductAPIService { get }
    var favoriteAPIService: FavoriteAPIService { get }
}

final class ProductHomeComponent: Component<ProductHomeDependency>,
                                  ProductSearchDependency,
                                  NotificationListDependency,
                                  ProductDetailDependency,
                                  ProductFilterDependency,
                                  EventDetailDependency,
                                  LoginPopupDependency,
                                  LoggedOutDependency {
    var appleLoginService: AppleLoginService
    var kakaoLoginService: KakaoLoginService
    var authClient: AuthAPIService
    var userAuthService: UserAuthService
    let productAPIService: ProductAPIService
    let favoriteAPIService: FavoriteAPIService
    
    override init(dependency: ProductHomeDependency) {
        self.appleLoginService = AppleLoginService()
        self.kakaoLoginService = KakaoLoginService()
        self.authClient = AuthAPIService(client: PyonsnalColorClient())
        self.userAuthService = UserAuthService(keyChainService: KeyChainService.shared)
        self.productAPIService = dependency.productAPIService
        self.favoriteAPIService = dependency.favoriteAPIService
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ProductHomeBuildable: Buildable {
    func build(withListener listener: ProductHomeListener) -> ProductHomeRouting
}

final class ProductHomeBuilder: Builder<ProductHomeDependency>, ProductHomeBuildable {

    override init(dependency: ProductHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductHomeListener) -> ProductHomeRouting {
        let component = ProductHomeComponent(dependency: dependency)
        let viewController = ProductHomeViewController()
        let interactor = ProductHomeInteractor(
            presenter: viewController,
            dependency: dependency
        )
        
        let productSearch: ProductSearchBuilder = .init(dependency: component)
        let notificationList: NotificationListBuilder = .init(dependency: component)
        let productDetail: ProductDetailBuilder = .init(dependency: component)
        let productFilter: ProductFilterBuilder = .init(dependency: component)
        let eventDetail: EventDetailBuilder = .init(dependency: component)
        let loginPopup: LoginPopupBuilder = .init(dependency: component)
        let loggedOut: LoggedOutBuilder = .init(dependency: component)
        
        interactor.listener = listener
        return ProductHomeRouter(
            interactor: interactor,
            viewController: viewController,
            productSearch: productSearch,
            notificationList: notificationList,
            productDetail: productDetail,
            productFilter: productFilter,
            eventDetail: eventDetail,
            loginPopup: loginPopup,
            loggedOut: loggedOut
        )
    }
}
