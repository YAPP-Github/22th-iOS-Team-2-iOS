//
//  CommonWebInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CommonWebPresentable: Presentable {
    var listener: CommonWebPresentableListener? { get set }
    func update(with subTermsInfo: SubTerms)
    func update(with settingInfo: SettingInfo)
    func update(with userEventDetail: UserEventDetail)
}

protocol CommonWebListener: AnyObject {
    func detachCommonWebView()
}

final class CommonWebInteractor: PresentableInteractor<CommonWebPresentable>, CommonWebInteractable, CommonWebPresentableListener {

    weak var router: CommonWebRouting?
    weak var listener: CommonWebListener?
    private let component: CommonWebComponent
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CommonWebPresentable,
        component: CommonWebComponent
    ) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if let subTerms = component.subTerms {
            self.presenter.update(with: subTerms)
        }else if let settingInfo = component.settingInfo {
            self.presenter.update(with: settingInfo)
        } else if let userEventDetail = component.userEventDetail {
            self.presenter.update(with: userEventDetail)
        } 
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func detachCommonWebView() {
        listener?.detachCommonWebView()
    }
}
