//
//  LoggedInInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol LoggedInRouting: Routing {
    func cleanupViews()
    func attachRootTabBar()
}

protocol LoggedInListener: AnyObject {
    func routeToLoggedOutFromLoggedIn()
    func routeToLoggedInFromLoggedOut()
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {
    
    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    func routeToLoggedOut() {
        listener?.routeToLoggedOutFromLoggedIn()
    }
    
    func routeToLoggedIn() {
        listener?.routeToLoggedInFromLoggedOut()
    }
}
