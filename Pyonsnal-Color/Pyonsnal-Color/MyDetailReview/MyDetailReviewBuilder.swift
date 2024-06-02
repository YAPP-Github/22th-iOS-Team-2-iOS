//
//  MyDetailReviewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyDetailReviewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyDetailReviewComponent: Component<MyDetailReviewDependency> {
    var productDetail: ProductDetailEntity
    var review: ReviewEntity
    
    init(dependency: MyDetailReviewDependency, productDetail: ProductDetailEntity, review: ReviewEntity) {
        self.productDetail = productDetail
        self.review = review
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MyDetailReviewBuildable: Buildable {
    func build(
        withListener listener: MyDetailReviewListener,
        productDetail: ProductDetailEntity,
        review: ReviewEntity
    ) -> MyDetailReviewRouting
}

final class MyDetailReviewBuilder: Builder<MyDetailReviewDependency>, MyDetailReviewBuildable {

    override init(dependency: MyDetailReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: MyDetailReviewListener,
        productDetail: ProductDetailEntity,
        review: ReviewEntity
    ) -> MyDetailReviewRouting {
        let component = MyDetailReviewComponent(dependency: dependency, productDetail: productDetail, review: review)
        let viewController = MyDetailReviewViewController()
        let interactor = MyDetailReviewInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return MyDetailReviewRouter(interactor: interactor, viewController: viewController)
    }
}
