//
//  ProductHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeInteractable: Interactable,
                                  ProductSearchListener,
                                  NotificationListListener,
                                  ProductDetailListener,
                                  ProductFilterListener,
                                  EventDetailListener,
                                  LoginPopupListener,
                                  LoggedOutListener {
    var router: ProductHomeRouting? { get set }
    var listener: ProductHomeListener? { get set }
}

protocol ProductHomeViewControllable: ViewControllable {
}

final class ProductHomeRouter:
    ViewableRouter<ProductHomeInteractable, ProductHomeViewControllable>,
    ProductHomeRouting {
    
    private let productSearch: ProductSearchBuildable
    private let notificationList: NotificationListBuildable
    private let productDetail: ProductDetailBuildable
    private let productFilter: ProductFilterBuildable
    private let eventDetail: EventDetailBuildable
    private let loginPopup: LoginPopupBuildable
    private let loggedOut: LoggedOutBuildable
    
    private var productSearchRouting: ProductSearchRouting?
    private var notificationListRouting: NotificationListRouting?
    private var productDetailRouting: ProductDetailRouting?
    private var productFilterRouting: ProductFilterRouting?
    private var eventDetailRouting: EventDetailRouting?
    private var loginPopupRouting: LoginPopupRouting?
    private var loggedOutRouting: LoggedOutRouting?
    
    init(
        interactor: ProductHomeInteractable,
        viewController: ProductHomeViewControllable,
        productSearch: ProductSearchBuildable,
        notificationList: NotificationListBuildable,
        productDetail: ProductDetailBuildable,
        productFilter: ProductFilterBuildable,
        eventDetail: EventDetailBuildable,
        loginPopup: LoginPopupBuildable,
        loggedOut: LoggedOutBuildable
    ) {
        self.productSearch = productSearch
        self.notificationList = notificationList
        self.productDetail = productDetail
        self.productFilter = productFilter
        self.eventDetail = eventDetail
        self.loginPopup = loginPopup
        self.loggedOut = loggedOut
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
    
    func attachNotificationList() {
        guard notificationListRouting == nil else { return }
        
        let notificationListRouting = notificationList.build(withListener: interactor)
        let viewController = notificationListRouting.viewControllable.uiviewController
        
        viewController.modalPresentationStyle = .fullScreen
        viewControllable.uiviewController.present(
            viewController,
            animated: true
        )
        
        self.notificationListRouting = notificationListRouting
        attachChild(notificationListRouting)
    }
    
    func detachNotificationList() {
        guard let router = notificationListRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: true)
        detachChild(router)
        notificationListRouting = nil
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
        viewControllable.uiviewController.present(
            productFilterViewController,
            animated: false
        )
    }
    
    func detachProductFilter() {
        guard let productFilterRouting else { return }
        viewController.uiviewController.dismiss(animated: false)
        detachChild(productFilterRouting)
        self.productFilterRouting = nil
    }
    
    func attachEventDetail(eventDetail: EventBannerDetailEntity) {
        guard eventDetailRouting == nil else { return }
        
        let eventDetailRouter = self.eventDetail.build(
            withListener: interactor,
            eventDetail: eventDetail
        )
        eventDetailRouting = eventDetailRouter
        attachChild(eventDetailRouter)
        viewControllable.pushViewController(eventDetailRouter.viewControllable, animated: true)
    }
    
    func detachEventDetail() {
        guard let eventDetailRouting else { return }
        
        viewController.popViewController(animated: true)
        detachChild(eventDetailRouting)
        self.eventDetailRouting = nil
    }
    
    func attachLoginPopup() {
        guard loginPopupRouting == nil else { return }
        
        let loginPopupRouter = loginPopup.build(withListener: interactor)
        let viewController = loginPopupRouter.viewControllable.uiviewController
        
        loginPopupRouting = loginPopupRouter
        attachChild(loginPopupRouter)
        viewController.modalPresentationStyle = .overFullScreen
        viewControllable.uiviewController.present(
            viewController,
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
