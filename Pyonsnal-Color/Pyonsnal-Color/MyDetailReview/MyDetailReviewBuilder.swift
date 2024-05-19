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

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MyDetailReviewBuildable: Buildable {
    func build(withListener listener: MyDetailReviewListener) -> MyDetailReviewRouting
}

final class MyDetailReviewBuilder: Builder<MyDetailReviewDependency>, MyDetailReviewBuildable {

    override init(dependency: MyDetailReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyDetailReviewListener) -> MyDetailReviewRouting {
        let component = MyDetailReviewComponent(dependency: dependency)
        let viewController = MyDetailReviewViewController()
        let interactor = MyDetailReviewInteractor(presenter: viewController)
        interactor.listener = listener
        return MyDetailReviewRouter(interactor: interactor, viewController: viewController)
    }
}
