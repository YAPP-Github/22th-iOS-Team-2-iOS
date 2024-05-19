//
//  MyReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyReviewInteractable: Interactable {
    var router: MyReviewRouting? { get set }
    var listener: MyReviewListener? { get set }
}

protocol MyReviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyReviewRouter: ViewableRouter<MyReviewInteractable, MyReviewViewControllable>, MyReviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MyReviewInteractable, viewController: MyReviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
