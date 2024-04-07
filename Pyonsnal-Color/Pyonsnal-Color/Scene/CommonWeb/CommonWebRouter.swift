//
//  CommonWebRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebInteractable: Interactable {
    var router: CommonWebRouting? { get set }
    var listener: CommonWebListener? { get set }
}

protocol CommonWebViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CommonWebRouter: ViewableRouter<CommonWebInteractable, CommonWebViewControllable>, CommonWebRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CommonWebInteractable, viewController: CommonWebViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
