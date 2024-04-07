//
//  FavoriteHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol FavoriteHomeInteractable: Interactable,
                                   ProductSearchListener,
                                   ProductDetailListener {
    var router: FavoriteHomeRouting? { get set }
    var listener: FavoriteHomeListener? { get set }
}

protocol FavoriteHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FavoriteHomeRouter: ViewableRouter<FavoriteHomeInteractable,
                            FavoriteHomeViewControllable>,
                            FavoriteHomeRouting {

    private let productSearch: ProductSearchBuildable
    private var productSearchRouting: ProductSearchRouting?
    
    private let productDetail: ProductDetailBuildable
    private var productDetailRouting: ProductDetailRouting?
    
    init(
        interactor: FavoriteHomeInteractable,
        viewController: FavoriteHomeViewControllable,
        productSearch: ProductSearchBuildable,
        productDetail: ProductDetailBuildable
    ) {
        self.productSearch = productSearch
        self.productDetail = productDetail
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachProductSearch() {
        guard productSearchRouting == nil else { return }
        
        let productSearchRouting = productSearch.build(withListener: interactor)
        let viewController = productSearchRouting.viewControllable
        
        viewControllable.pushViewController(
            viewController,
            animated: true
        )
        
        self.productSearchRouting = productSearchRouting
        attachChild(productSearchRouting)
    }
    
    func detachProductSearch() {
        guard let productSearchRouting else { return }
        
        viewControllable.popViewController(animated: true)
        self.productSearchRouting = nil
        detachChild(productSearchRouting)
    }
    
    func attachProductDetail(with product: ProductDetailEntity) {
        if productDetailRouting != nil { return }
        
        let productDetailRouter = productDetail.build(withListener: interactor, product: product)
        productDetailRouting = productDetailRouter
        attachChild(productDetailRouter)
        viewControllable.pushViewController(productDetailRouter.viewControllable, animated: true)
    }
    
    func detachProductDetail() {
        guard let productDetailRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(productDetailRouting)
        self.productDetailRouting = nil
    }
    
}
