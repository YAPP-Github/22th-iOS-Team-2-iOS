//
//  ReviewPopupBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol ReviewPopupDependency: Dependency {
}

final class ReviewPopupComponent: Component<ReviewPopupDependency> {
}

// MARK: - Builder

protocol ReviewPopupBuildable: Buildable {
    func build(withListener listener: ReviewPopupListener) -> ReviewPopupRouting
    func build(withListener listener: ReviewPopupListener, isApply: Bool) -> ReviewPopupRouting
}

final class ReviewPopupBuilder: Builder<ReviewPopupDependency>, ReviewPopupBuildable {

    override init(dependency: ReviewPopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReviewPopupListener) -> ReviewPopupRouting {
        let component = ReviewPopupComponent(dependency: dependency)
        let viewController = ReviewPopupViewController()
        let interactor = ReviewPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return ReviewPopupRouter(interactor: interactor, viewController: viewController)
    }
    
    func build(withListener listener: ReviewPopupListener, isApply: Bool) -> ReviewPopupRouting {
        let component = ReviewPopupComponent(dependency: dependency)
        let viewController = ReviewPopupViewController(isApply: isApply)
        let interactor = ReviewPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return ReviewPopupRouter(interactor: interactor, viewController: viewController)
    }
}
