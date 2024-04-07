//
//  RootRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/29.
//

import ModernRIBs

protocol RootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModel(viewController: ViewControllable)
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // MARK: - Private Property
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOut: ViewableRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedIn: Routing?

    // MARK: - Initializer
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        loggedOutBuilder: LoggedOutBuildable,
        loggedInBuilder: LoggedInBuildable
    ) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        super.init(interactor: interactor, viewController: viewController)

        interactor.router = self
    }

    func routeToLoggedOut() {
        if loggedOut != nil { return }
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        self.loggedOut = loggedOut
        attachChild(loggedOut)
        viewController.replaceModel(viewController: loggedOut.viewControllable)
    }
    
    func routeToLoggedIn() {
        if let loggedOut {
            detachChild(loggedOut)
            viewController.dismiss(viewController: loggedOut.viewControllable)
            self.loggedOut = nil
        }
        
        let loggedIn = loggedInBuilder.build(withListener: interactor)
        self.loggedIn = loggedIn
        attachChild(loggedIn)
    }
    
    func routeToLoggedOutFromLogIn() {
        if let loggedIn {
            detachChild(loggedIn)
            self.loggedIn = nil
        }
        
        routeToLoggedOut()
    }
    
    func routeToLoggedInFromLoggedOut() {
        if let loggedOut {
            detachChild(loggedOut)
            self.loggedOut = nil
        }
        routeToLoggedIn()
    }
    
}
