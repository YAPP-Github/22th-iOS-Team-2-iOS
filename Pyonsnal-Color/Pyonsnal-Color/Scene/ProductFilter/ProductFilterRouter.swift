//
//  ProductFilterRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import ModernRIBs

protocol ProductFilterInteractable: Interactable {
    var router: ProductFilterRouting? { get set }
    var listener: ProductFilterListener? { get set }
}

protocol ProductFilterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductFilterRouter: ViewableRouter<ProductFilterInteractable, ProductFilterViewControllable>, ProductFilterRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductFilterInteractable, viewController: ProductFilterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
