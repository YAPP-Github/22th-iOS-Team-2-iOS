//
//  ProductFilterBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import ModernRIBs

protocol ProductFilterDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductFilterComponent: Component<ProductFilterDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductFilterBuildable: Buildable {
    func build(
        withListener listener: ProductFilterListener,
        filterEntity: FilterEntity
    ) -> ProductFilterRouting
}

final class ProductFilterBuilder: Builder<ProductFilterDependency>, ProductFilterBuildable {

    override init(dependency: ProductFilterDependency) {
        super.init(dependency: dependency)
    }
    
    func build(
        withListener listener: ProductFilterListener,
        filterEntity: FilterEntity
    ) -> ProductFilterRouting {
        let component = ProductFilterComponent(dependency: dependency)
        let viewController = ProductFilterViewController(filterEntity: filterEntity)
        let interactor = ProductFilterInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductFilterRouter(interactor: interactor, viewController: viewController)
    }
}
