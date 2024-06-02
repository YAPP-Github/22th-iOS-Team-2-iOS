//
//  MyReviewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyReviewDependency: Dependency { }

final class MyReviewComponent: Component<MyReviewDependency>,
                               MyDetailReviewDependency {}

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
        let myDetailReviewBuilder = MyDetailReviewBuilder(dependency: component)
        let interactor = MyReviewInteractor(presenter: viewController)
        interactor.listener = listener
        return MyReviewRouter(interactor: interactor, viewController: viewController, myDetailReviewBuilder: myDetailReviewBuilder)
    }
}
