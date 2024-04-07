//
//  ProductDetailBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailDependency: Dependency {
    var productAPIService: ProductAPIService { get }
}

final class ProductDetailComponent: Component<ProductDetailDependency>, 
                                    StarRatingReviewDependency,
                                    ProductFilterDependency,
                                    LoginPopupDependency,
                                    LoggedOutDependency {

    fileprivate let favoriteAPIService: FavoriteAPIService
    let client = PyonsnalColorClient()
    let userAuthService = UserAuthService(keyChainService: KeyChainService.shared)
    let appleLoginService: AppleLoginService
    let kakaoLoginService: KakaoLoginService
    let authClient: AuthAPIService
    
    override init(dependency: ProductDetailDependency) {
        self.favoriteAPIService = FavoriteAPIService(client: client, userAuthService: userAuthService)
        self.appleLoginService = AppleLoginService()
        self.kakaoLoginService = KakaoLoginService()
        self.authClient = AuthAPIService(client: client)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ProductDetailBuildable: Buildable {
    func build(
        withListener listener: ProductDetailListener,
        product: ProductDetailEntity
    ) -> ProductDetailRouting
}

final class ProductDetailBuilder: Builder<ProductDetailDependency>, ProductDetailBuildable {

    override init(dependency: ProductDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductDetailListener, product: ProductDetailEntity) -> ProductDetailRouting {
        let component = ProductDetailComponent(dependency: dependency)
        let viewController = ProductDetailViewController()
        let interactor = ProductDetailInteractor(
            presenter: viewController,
            favoriteAPIService: component.favoriteAPIService,
            dependency: dependency,
            product: product
        )
        let starRatingReview: StarRatingReviewBuilder = .init(dependency: component)
        let productFilter: ProductFilterBuilder = .init(dependency: component)
        let loginPopup: LoginPopupBuilder = .init(dependency: component)
        let loggedOut: LoggedOutBuilder = .init(dependency: component)
        
        interactor.listener = listener
        return ProductDetailRouter(
            interactor: interactor,
            viewController: viewController,
            starRatingReview: starRatingReview,
            productFilter: productFilter,
            loginPopup: loginPopup,
            loggedOut: loggedOut
        )
    }
}
