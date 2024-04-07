//
//  EventDetailInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs

protocol EventDetailRouting: ViewableRouting {
    func attachCommonWeb(with userEventDetail: UserEventDetail)
    func detachCommonWeb()
}

protocol EventDetailPresentable: Presentable {
    var listener: EventDetailPresentableListener? { get set }
    func update(with imageURL: String, store: ConvenienceStore)
    func update(with eventDetail: EventBannerDetailEntity)
}

protocol EventDetailListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailInteractor: PresentableInteractor<EventDetailPresentable>,
                                   EventDetailInteractable,
                                   EventDetailPresentableListener {
    
    private let component: EventDetailComponent
    
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?

    init(
        presenter: EventDetailPresentable,
        component: EventDetailComponent
    ) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let store = component.store {
            presenter.update(with: component.imageURL, store: store)
        } else if let eventDetail = component.eventDetail {
//            let urls = Array(repeating: "https://www.metavv.com/ko/content/preview/result/10895901/1?score=INFJ", count: 48)
            presenter.update(with: eventDetail)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
    
    func didTapUserEvent(with urlString: String) {
        let userEventDetail = UserEventDetail(title: "이벤트", urlString: urlString)
        router?.attachCommonWeb(with: userEventDetail)
    }
    
    func detachCommonWebView() {
        router?.detachCommonWeb()
    }
}
