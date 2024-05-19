//
//  MyDetailReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyDetailReviewInteractable: Interactable {
    var router: MyDetailReviewRouting? { get set }
    var listener: MyDetailReviewListener? { get set }
}

protocol MyDetailReviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyDetailReviewRouter: ViewableRouter<MyDetailReviewInteractable, MyDetailReviewViewControllable>, MyDetailReviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MyDetailReviewInteractable, viewController: MyDetailReviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
