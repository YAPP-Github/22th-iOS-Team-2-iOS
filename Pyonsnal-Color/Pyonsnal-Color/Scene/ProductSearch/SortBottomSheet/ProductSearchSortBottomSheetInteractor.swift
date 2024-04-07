//
//  ProductSearchSortBottomSheetInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import ModernRIBs

protocol ProductSearchSortBottomSheetRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductSearchSortBottomSheetPresentable: Presentable {
    var listener: ProductSearchSortBottomSheetPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductSearchSortBottomSheetListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProductSearchSortBottomSheetInteractor: PresentableInteractor<ProductSearchSortBottomSheetPresentable>, ProductSearchSortBottomSheetInteractable, ProductSearchSortBottomSheetPresentableListener {

    weak var router: ProductSearchSortBottomSheetRouting?
    weak var listener: ProductSearchSortBottomSheetListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProductSearchSortBottomSheetPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
