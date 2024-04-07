//
//  EventDetailRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs

protocol EventDetailInteractable: Interactable, CommonWebListener {
    var router: EventDetailRouting? { get set }
    var listener: EventDetailListener? { get set }
}

protocol EventDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventDetailRouter: ViewableRouter<EventDetailInteractable, EventDetailViewControllable>,
                               EventDetailRouting {
    
    private let commonWebBuilder: CommonWebBuildable?
    private var commonWebRouting: CommonWebRouting?
    
    init(
        interactor: EventDetailInteractable,
        viewController: EventDetailViewControllable,
        commonWebBuilder: CommonWebBuilder? = nil
    ) {
        self.commonWebBuilder = commonWebBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachCommonWeb(with userEventDetail: UserEventDetail) {
        guard commonWebRouting == nil else { return }
        guard let commonWebRouter = commonWebBuilder?.build(
            withListener: interactor,
            userEventDetail: userEventDetail
        ) else {
            return
        }
        
        self.commonWebRouting = commonWebRouter
        attachChild(commonWebRouter)
        viewController.pushViewController(commonWebRouter.viewControllable, animated: true)
    }

    func detachCommonWeb() {
        guard let commonWebRouting else { return }
        self.commonWebRouting = nil
        detachChild(commonWebRouting)
        viewController.popViewController(animated: true)
    }
}
