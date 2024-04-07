//
//  ProductSearchSortBottomSheetRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import ModernRIBs

protocol ProductSearchSortBottomSheetInteractable: Interactable {
    var router: ProductSearchSortBottomSheetRouting? { get set }
    var listener: ProductSearchSortBottomSheetListener? { get set }
}

protocol ProductSearchSortBottomSheetViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductSearchSortBottomSheetRouter: ViewableRouter<ProductSearchSortBottomSheetInteractable, ProductSearchSortBottomSheetViewControllable>, ProductSearchSortBottomSheetRouting {

    override init(interactor: ProductSearchSortBottomSheetInteractable, viewController: ProductSearchSortBottomSheetViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
