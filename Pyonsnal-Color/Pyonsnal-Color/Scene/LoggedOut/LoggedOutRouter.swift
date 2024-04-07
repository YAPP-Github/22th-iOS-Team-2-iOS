//
//  LoggedOutRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import ModernRIBs

protocol LoggedOutInteractable: Interactable,
                                TermsOfUseListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable {
}

final class LoggedOutRouter: ViewableRouter<LoggedOutInteractable, LoggedOutViewControllable>,
                             LoggedOutRouting {
    
    private let termsOfUseBuilder: TermsOfUseBuilder
    private var termsOfUseRouting: ViewableRouting?
    
    init(
        interactor: LoggedOutInteractable,
        viewController: LoggedOutViewControllable,
        termsOfUseBuilder: TermsOfUseBuilder
    ) {
        self.termsOfUseBuilder = termsOfUseBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTermsOfUse() {
        guard termsOfUseRouting == nil else { return }
        let termsOfUseRouter = termsOfUseBuilder.build(withListener: interactor)
        termsOfUseRouting = termsOfUseRouter
        attachChild(termsOfUseRouter)
        if let termsOfUseViewController = termsOfUseRouting?.viewControllable.uiviewController {
            termsOfUseViewController.modalPresentationStyle = .overFullScreen
            viewController.uiviewController.present(termsOfUseViewController, animated: true)
        }
    }
    
    func detachTermsOfUse() {
        if let termsOfUseRouting {
            self.termsOfUseRouting = nil
            detachChild(termsOfUseRouting)
            viewController.uiviewController.dismiss(animated: true)
        }
       
    }
    
}
