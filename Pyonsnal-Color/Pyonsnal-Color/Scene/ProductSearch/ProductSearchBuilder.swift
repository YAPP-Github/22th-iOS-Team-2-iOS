//
//  ProductSearchBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs

protocol ProductSearchDependency: Dependency {
    var productAPIService: ProductAPIService { get }
    var favoriteAPIService: FavoriteAPIService { get }
}

final class ProductSearchComponent: Component<ProductSearchDependency>,
                                    ProductSearchSortBottomSheetDependency,
                                    ProductFilterDependency,
                                    ProductDetailDependency,
                                    LoginPopupDependency,
                                    LoggedOutDependency {
    var appleLoginService: AppleLoginService
    var kakaoLoginService: KakaoLoginService
    var authClient: AuthAPIService
    var userAuthService: UserAuthService
    var productAPIService: ProductAPIService
    
    override init(dependency: ProductSearchDependency) {
        self.appleLoginService = AppleLoginService()
        self.kakaoLoginService = KakaoLoginService()
        self.authClient = AuthAPIService(client: PyonsnalColorClient())
        self.userAuthService = UserAuthService(keyChainService: KeyChainService.shared)
        self.productAPIService = dependency.productAPIService
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ProductSearchBuildable: Buildable {
    func build(withListener listener: ProductSearchListener) -> ProductSearchRouting
}

final class ProductSearchBuilder: Builder<ProductSearchDependency>, ProductSearchBuildable {

    override init(dependency: ProductSearchDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductSearchListener) -> ProductSearchRouting {
        let component = ProductSearchComponent(dependency: dependency)
        let viewController = ProductSearchViewController()
        let interactor = ProductSearchInteractor(presenter: viewController, dependency: dependency)
        
        let prodcutSearchSortBottomSheet: ProductSearchSortBottomSheetBuilder = .init(
            dependency: component
        )
        let productFilter: ProductFilterBuilder = .init(dependency: component)
        let productDetail: ProductDetailBuilder = .init(dependency: component)
        let loginPopup: LoginPopupBuilder = .init(dependency: component)
        let loggedOut: LoggedOutBuilder = .init(dependency: component)
        
        interactor.listener = listener
        return ProductSearchRouter(
            interactor: interactor,
            viewController: viewController,
            productSearchSortBottomSheet: prodcutSearchSortBottomSheet,
            productFilter: productFilter,
            productDetail: productDetail,
            loginPopup: loginPopup,
            loggedOut: loggedOut
        )
    }
}
