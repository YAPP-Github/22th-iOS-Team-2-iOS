//
//  LoggedInRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol LoggedInInteractable: Interactable, RootTabBarListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    private let rootTabBarBuilder: RootTabBarBuildable
    private var rootTabBarRouting: ViewableRouting?
    
    init(
        interactor: LoggedInInteractable,
        viewController: LoggedInViewControllable,
        rootTabBarBuilder: RootTabBarBuildable
    ) {
        self.viewController = viewController
        self.rootTabBarBuilder = rootTabBarBuilder
        super.init(interactor: interactor)
        
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
            
        attachRootTabBar()
    }
    
    func attachRootTabBar() {
        let rootTabBar = rootTabBarBuilder.build(withListener: interactor)
        
        self.rootTabBarRouting = rootTabBar
        attachChild(rootTabBar)
        viewController.present(viewController: rootTabBar.viewControllable)
    }

    func cleanupViews() {
        if let rootTabBarRouting {
            viewController.dismiss(viewController: rootTabBarRouting.viewControllable)
        }
    }

    // MARK: - Private
    private let viewController: LoggedInViewControllable
}
