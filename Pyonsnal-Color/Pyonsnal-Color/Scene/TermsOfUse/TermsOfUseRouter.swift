//
//  TermsOfUseRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/06.
//

import ModernRIBs

protocol TermsOfUseInteractable: Interactable,
                                 CommonWebListener {
    var router: TermsOfUseRouting? { get set }
    var listener: TermsOfUseListener? { get set }
}

protocol TermsOfUseViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TermsOfUseRouter: ViewableRouter<TermsOfUseInteractable,
                              TermsOfUseViewControllable>,
                              TermsOfUseRouting {
    
    private let commonWebBuilder: CommonWebBuildable
    private var commonWebRouting: ViewableRouting?
    
    init(
        interactor: TermsOfUseInteractable,
        viewController: TermsOfUseViewControllable,
        commonWebBuilder: CommonWebBuildable
    ) {
        self.commonWebBuilder = commonWebBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachCommonWebView(with terms: SubTerms) {
        if commonWebRouting != nil { return }
        let commonWebBuilder = commonWebBuilder.build(withListener: interactor, subTerms: terms)
        self.commonWebRouting = commonWebBuilder
        attachChild(commonWebBuilder)
        commonWebBuilder.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(commonWebBuilder.viewControllable.uiviewController, animated: true)
    }

    func detachCommonWebView() {
        guard let commonWebRouting else { return }
        self.commonWebRouting = nil
        detachChild(commonWebRouting)
        viewController.uiviewController.dismiss(animated: true)
    }
}
