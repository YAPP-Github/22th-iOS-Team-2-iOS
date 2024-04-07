//
//  LogoutPopupRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs

protocol LogoutPopupInteractable: Interactable {
    var router: LogoutPopupRouting? { get set }
    var listener: LogoutPopupListener? { get set }
}

protocol LogoutPopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LogoutPopupRouter: ViewableRouter<LogoutPopupInteractable, LogoutPopupViewControllable>, LogoutPopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: LogoutPopupInteractable, viewController: LogoutPopupViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
