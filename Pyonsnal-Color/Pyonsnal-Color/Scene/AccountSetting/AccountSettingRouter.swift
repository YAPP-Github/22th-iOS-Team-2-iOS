//
//  AccountSettingRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs

protocol AccountSettingInteractable: Interactable,
                                     LogoutPopupListener,
                                     CommonWebListener {
    var router: AccountSettingRouting? { get set }
    var listener: AccountSettingListener? { get set }
}

protocol AccountSettingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AccountSettingRouter: ViewableRouter<AccountSettingInteractable,
                                  AccountSettingViewControllable>,
                                  AccountSettingRouting {    

    private let logoutPopupBuildable: LogoutPopupBuildable
    private var logoutPopupRouting: LogoutPopupRouting?
    
    private let commonWebBuilderable: CommonWebBuildable
    private var commonWebRouting: ViewableRouting?
    
    init(
        interactor: AccountSettingInteractable,
        viewController: AccountSettingViewControllable,
        logoutPopupBuilder: LogoutPopupBuildable,
        commonWebBuilderable: CommonWebBuilder
    ) {
        self.logoutPopupBuildable = logoutPopupBuilder
        self.commonWebBuilderable = commonWebBuilderable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPopup(isLogout: Bool) {
        guard logoutPopupRouting == nil else { return }
        
        let logoutPopupRouter = logoutPopupBuildable.build(
            withListener: interactor,
            isLogout: isLogout
        )
        self.logoutPopupRouting = logoutPopupRouter
        attachChild(logoutPopupRouter)
        let logoutPopup = logoutPopupRouter.viewControllable.uiviewController
        logoutPopup.modalPresentationStyle = .overFullScreen
        viewController.uiviewController.present(logoutPopup, animated: false)
    }
    
    func detachPopup() {
        guard let logoutPopupRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: false)
        detachChild(logoutPopupRouting)
        self.logoutPopupRouting = nil
    }
    
    func attachCommonWebView(with subTerms: SubTerms) {
        if commonWebRouting != nil { return }
        let commonWebBuilder = commonWebBuilderable.build(withListener: interactor, subTerms: subTerms)
        self.commonWebRouting = commonWebBuilder
        attachChild(commonWebBuilder)
        viewController.pushViewController(commonWebBuilder.viewControllable, animated: true)
        
    }
    
    func detachCommonWebView() {
        guard let commonWebRouting else { return }
        self.commonWebRouting = nil
        detachChild(commonWebRouting)
        viewController.popViewController(animated: true)
    }
}
