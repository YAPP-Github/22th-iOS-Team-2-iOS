//
//  MyReviewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyReviewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyReviewComponent: Component<MyReviewDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MyReviewBuildable: Buildable {
    func build(withListener listener: MyReviewListener) -> MyReviewRouting
}

final class MyReviewBuilder: Builder<MyReviewDependency>, MyReviewBuildable {

    override init(dependency: MyReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyReviewListener) -> MyReviewRouting {
        let component = MyReviewComponent(dependency: dependency)
        let viewController = MyReviewViewController()
        let interactor = MyReviewInteractor(presenter: viewController)
        interactor.listener = listener
        return MyReviewRouter(interactor: interactor, viewController: viewController)
    }
}
