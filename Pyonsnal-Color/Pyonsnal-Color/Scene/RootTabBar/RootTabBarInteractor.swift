//
//  RootTabBarInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootTabBarRouting: ViewableRouting {
    func attachTabs()
}

protocol RootTabBarPresentable: Presentable {
    var listener: RootTabBarPresentableListener? { get set }
}

protocol RootTabBarListener: AnyObject {
    func routeToLoggedOut()
    func routeToLoggedIn()
}

final class RootTabBarInteractor:
    PresentableInteractor<RootTabBarPresentable>,
    RootTabBarInteractable,
    RootTabBarPresentableListener {

    weak var router: RootTabBarRouting?
    weak var listener: RootTabBarListener?

    override init(presenter: RootTabBarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTabs()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func routeToLoggedOut() {
        listener?.routeToLoggedOut()
    }
    
    func routeToLoggedIn() {
        listener?.routeToLoggedIn()
    }
}
