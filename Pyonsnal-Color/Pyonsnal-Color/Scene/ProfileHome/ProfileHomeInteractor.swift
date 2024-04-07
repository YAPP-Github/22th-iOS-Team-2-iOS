//
//  ProfileHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import Combine

protocol ProfileHomeRouting: ViewableRouting {
    func attachProfileEdit(with memberInfo: MemberInfoEntity)
    func detachProfileEdit()
    
    func attachCommonWebView(with settingInfo: SettingInfo)
    func detachCommonWebView()
    
    func attachAccountSetting()
    func detachAccountSetting()
    
    func attachLoggedOut()
    func detachLoggedOut()
}

protocol ProfileHomePresentable: Presentable {
    var listener: ProfileHomePresentableListener? { get set }
    func update(with member: MemberInfoEntity)
}

protocol ProfileHomeListener: AnyObject {
    func routeToLoggedOut()
    func routeToLoggedIn()
}

final class ProfileHomeInteractor: PresentableInteractor<ProfileHomePresentable>,
                                   ProfileHomeInteractable,
                                   ProfileHomePresentableListener {
    
    weak var router: ProfileHomeRouting?
    weak var listener: ProfileHomeListener?
    private var cancellable = Set<AnyCancellable>()
    private var component: ProfileHomeComponent
    
    init(presenter: ProfileHomePresentable, component: ProfileHomeComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        requestMemberInfo()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func requestMemberInfo() {
        component.memberAPIService.info()
            .sink { [weak self] response in
                if let memberInfo = response.value {
                    Log.d(message: "info success: \(memberInfo)")
                    Log.d(message: "isGuest \(memberInfo.isGuest)")
                    self?.presenter.update(with: memberInfo)
                }
            }.store(in: &cancellable)
    }
    
    func didTapAccountSetting() {
        router?.attachAccountSetting()
    }
    
    func didTapTeams(with settingInfo: SettingInfo) {
        router?.attachCommonWebView(with: settingInfo)
    }
    
    func didTapProfileEditButton(memberInfo: MemberInfoEntity) {
        guard !memberInfo.isGuest else {
            self.attachLoggedOut()
            return
        }
        router?.attachProfileEdit(with: memberInfo)
    }
    
    func didTapBackButton() {
        router?.detachAccountSetting()
    }
    
    func attachLoggedOut() {
        router?.attachLoggedOut()
    }
    
    func routeToLoggedOut() {
        listener?.routeToLoggedOut()
    }
    
    func detachCommonWebView() {
        router?.detachCommonWebView()
    }
    
    func detachProfileEditView() {
        router?.detachProfileEdit()
    }
    
    func routeToLoggedIn() {
        listener?.routeToLoggedIn()
    }
    
    func detachLoggedOut() {
        router?.detachLoggedOut()
    }
    
}
