//
//  FavoriteHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol FavoriteHomeDependency: Dependency {
    var productAPIService: ProductAPIService { get }
    var favoriteAPIService: FavoriteAPIService { get }
}

final class FavoriteHomeComponent: Component<FavoriteHomeDependency>,
                               ProductSearchDependency,
                               ProductDetailDependency {
    var productAPIService: ProductAPIService
    var favoriteAPIService: FavoriteAPIService
    
    override init(dependency: FavoriteHomeDependency) {
        self.productAPIService = dependency.productAPIService
        self.favoriteAPIService = dependency.favoriteAPIService
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FavoriteHomeBuildable: Buildable {
    func build(withListener listener: FavoriteHomeListener) -> FavoriteHomeRouting
}

final class FavoriteHomeBuilder: Builder<FavoriteHomeDependency>, FavoriteHomeBuildable {

    override init(dependency: FavoriteHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FavoriteHomeListener) -> FavoriteHomeRouting {
        let component = FavoriteHomeComponent(dependency: dependency)
        let viewController = FavoriteHomeViewController()
        
        let productSearch = ProductSearchBuilder(dependency: component)
        let productDetail = ProductDetailBuilder(dependency: component)
        
        let interactor = FavoriteHomeInteractor(
            presenter: viewController,
            favoriteAPIService: component.favoriteAPIService
        )
        interactor.listener = listener
        return FavoriteHomeRouter(
            interactor: interactor,
            viewController: viewController,
            productSearch: productSearch,
            productDetail: productDetail
        )
    }
}
