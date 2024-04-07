//
//  ProductSearchSortBottomSheetBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import ModernRIBs

protocol ProductSearchSortBottomSheetDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductSearchSortBottomSheetComponent: Component<ProductSearchSortBottomSheetDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductSearchSortBottomSheetBuildable: Buildable {
    func build(withListener listener: ProductSearchSortBottomSheetListener) -> ProductSearchSortBottomSheetRouting
}

final class ProductSearchSortBottomSheetBuilder: Builder<ProductSearchSortBottomSheetDependency>, ProductSearchSortBottomSheetBuildable {

    override init(dependency: ProductSearchSortBottomSheetDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductSearchSortBottomSheetListener) -> ProductSearchSortBottomSheetRouting {
        let component = ProductSearchSortBottomSheetComponent(dependency: dependency)
        let viewController = ProductSearchSortBottomSheetViewController()
        let interactor = ProductSearchSortBottomSheetInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductSearchSortBottomSheetRouter(interactor: interactor, viewController: viewController)
    }
}
