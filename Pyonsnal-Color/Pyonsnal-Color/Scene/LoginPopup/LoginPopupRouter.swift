//
//  LoginPopupRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import ModernRIBs

protocol LoginPopupInteractable: Interactable {
    var router: LoginPopupRouting? { get set }
    var listener: LoginPopupListener? { get set }
}

protocol LoginPopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LoginPopupRouter: ViewableRouter<LoginPopupInteractable, LoginPopupViewControllable>, LoginPopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: LoginPopupInteractable, viewController: LoginPopupViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
