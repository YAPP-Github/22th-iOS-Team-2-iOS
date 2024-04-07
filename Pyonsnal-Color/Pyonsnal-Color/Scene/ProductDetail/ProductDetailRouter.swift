//
//  ProductDetailRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailInteractable: Interactable, 
                                    StarRatingReviewListener,
                                    ProductFilterListener,
                                    LoginPopupListener,
                                    LoggedOutListener {
    var router: ProductDetailRouting? { get set }
    var listener: ProductDetailListener? { get set }
}

protocol ProductDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductDetailRouter: ViewableRouter<ProductDetailInteractable, ProductDetailViewControllable>, ProductDetailRouting {
    
    private let productFilter: ProductFilterBuildable
    private var productFilterRouting: ProductFilterRouting?
    
    private let starRatingReview: StarRatingReviewBuildable
    private var starRatingReviewRouting: StarRatingReviewRouting?
    
    private let loginPopup: LoginPopupBuildable
    private var loginPopupRouting: LoginPopupRouting?
    
    private let loggedOut: LoggedOutBuildable
    private var loggedOutRouting: LoggedOutRouting?

    // TODO: Constructor inject child builder protocols to allow building children.

    init(
        interactor: ProductDetailInteractable,
        viewController: ProductDetailViewControllable,
        starRatingReview: StarRatingReviewBuildable,
        productFilter: ProductFilterBuildable,
        loginPopup: LoginPopupBuildable,
        loggedOut: LoggedOutBuildable
    ) {
        self.starRatingReview = starRatingReview
        self.productFilter = productFilter
        self.loginPopup = loginPopup
        self.loggedOut = loggedOut
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachStarRatingReview(with productDetail: ProductDetailEntity) {
        guard starRatingReviewRouting == nil else { return }
        
        let starRatingReviewRouter = starRatingReview.build(
            withListener: interactor,
            productDetail: productDetail
        )
        starRatingReviewRouting = starRatingReviewRouter
        attachChild(starRatingReviewRouter)
        viewController.pushViewController(starRatingReviewRouter.viewControllable, animated: true)
    }
    
    func detachStarRatingReview() {
        guard let starRatingReviewRouting else { return }
        
        viewController.popViewController(animated: true)
        self.starRatingReviewRouting = nil
        detachChild(starRatingReviewRouting)
    }

    func attachProductFilter(of filter: FilterEntity) {
        guard productFilterRouting == nil else { return }
        
        let productFilterRouter = productFilter.build(
            withListener: interactor,
            filterEntity: filter
        )
        let productFilterViewController = productFilterRouter.viewControllable.uiviewController
        productFilterViewController.modalPresentationStyle = .overFullScreen
        productFilterRouting = productFilterRouter
        attachChild(productFilterRouter)
        viewControllable.uiviewController.present(productFilterViewController, animated: false)
    }
    
    func detachProductFilter() {
        guard let productFilterRouting else { return }
        viewController.uiviewController.dismiss(animated: false)
        self.productFilterRouting = nil
        detachChild(productFilterRouting)
    }
    
    func attachLoginPopup() {
        guard loginPopupRouting == nil else { return }
        
        let loginPopupRouter = loginPopup.build(withListener: interactor)
        let viewController = loginPopupRouter.viewControllable.uiviewController
        
        loginPopupRouting = loginPopupRouter
        attachChild(loginPopupRouter)
        viewController.modalPresentationStyle = .overFullScreen
        viewControllable.uiviewController.present(
            loginPopupRouter.viewControllable.uiviewController,
            animated: false
        )
    }
    
    func detachLoginPopup() {
        guard let loginPopupRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: false)
        detachChild(loginPopupRouting)
        self.loginPopupRouting = nil
    }
    
    func attachLoggedOut() {
        guard loggedOutRouting == nil else { return }
        
        let loggedOutRouter = loggedOut.build(withListener: interactor)
        let viewController = loggedOutRouter.viewControllable.uiviewController
        
        loggedOutRouting = loggedOutRouter
        attachChild(loggedOutRouter)
        viewController.modalPresentationStyle = .overFullScreen
        viewControllable.uiviewController.present(
            viewController,
            animated: true
        )
    }
    
    func detachLoggedOut(animated: Bool = true) {
        guard let loggedOutRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: animated)
        detachChild(loggedOutRouting)
        self.loggedOutRouting = nil
    }
}
