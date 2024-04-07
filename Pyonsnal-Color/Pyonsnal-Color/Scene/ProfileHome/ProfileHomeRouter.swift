//
//  ProfileHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProfileHomeInteractable: Interactable,
                                  ProfileEditListener,
                                  AccountSettingListener,
                                  CommonWebListener,
                                  LoggedOutListener {
    var router: ProfileHomeRouting? { get set }
    var listener: ProfileHomeListener? { get set }
    func requestMemberInfo()
}

protocol ProfileHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileHomeRouter: ViewableRouter<ProfileHomeInteractable,
                               ProfileHomeViewControllable>,
                               ProfileHomeRouting {
    
    
    private let profileEditBuilder: ProfileEditBuildable
    private var profileEditRouting: ViewableRouting?
    
    private let commonWebBuilder: CommonWebBuildable
    private var commonWebRouting: ViewableRouting?
    
    private let accountSettingBuilder: AccountSettingBuildable
    private var accountSetting: ViewableRouting?
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouting: ViewableRouting?

    init(
        interactor: ProfileHomeInteractable,
        viewController: ProfileHomeViewControllable,
        profileEditBuilder: ProfileEditBuildable,
        accountSettingBuilder: AccountSettingBuildable,
        commonWebBuilder: CommonWebBuilder,
        loggedOutBuilder: LoggedOutBuilder
    ) {
        self.profileEditBuilder = profileEditBuilder
        self.accountSettingBuilder = accountSettingBuilder
        self.commonWebBuilder = commonWebBuilder
        self.loggedOutBuilder = loggedOutBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachProfileEdit(with memberInfo: MemberInfoEntity) {
        if profileEditRouting != nil { return }
        let profileEditRouter = profileEditBuilder.build(
            withListener: interactor,
            memberInfo: memberInfo
        )
        profileEditRouting = profileEditRouter
        attachChild(profileEditRouter)
        viewController.pushViewController(profileEditRouter.viewControllable, animated: true)
    }
    
    func detachProfileEdit() {
        guard let profileEditRouting else { return }
        viewController.popViewController(animated: true)
        self.profileEditRouting = nil
        detachChild(profileEditRouting)
        interactor.requestMemberInfo()
    }
    
    func attachAccountSetting() {
        if accountSetting != nil { return }
        let accountSettingRouter = accountSettingBuilder.build(withListener: interactor)
        accountSetting = accountSettingRouter
        attachChild(accountSettingRouter)
        viewController.pushViewController(accountSettingRouter.viewControllable, animated: true)
    }
    
    func detachAccountSetting() {
        guard let accountSetting else { return }
        viewController.popViewController(animated: true)
        self.accountSetting = nil
        detachChild(accountSetting)
    }
    
    func attachCommonWebView(with settingInfo: SettingInfo) {
        if commonWebRouting != nil { return }
        let commonWebBuilder = commonWebBuilder.build(
            withListener: interactor,
            settingInfo: settingInfo
        )
        self.commonWebRouting = commonWebBuilder
        attachChild(commonWebBuilder)
        commonWebBuilder.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(commonWebBuilder.viewControllable.uiviewController,
                                                animated: true)
    }

    func detachCommonWebView() {
        guard let commonWebRouting else { return }
        self.commonWebRouting = nil
        detachChild(commonWebRouting)
        viewController.uiviewController.dismiss(animated: true)
    }
    
    func attachLoggedOut() {
        if loggedOutRouting != nil { return }
        let loggedOutBuilder = loggedOutBuilder.build(withListener: interactor)
        self.loggedOutRouting = loggedOutBuilder
        attachChild(loggedOutBuilder)
        loggedOutBuilder.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(loggedOutBuilder.viewControllable.uiviewController,
                                                animated: true)
    }
    
    func detachLoggedOut() {
        guard let loggedOutRouting else { return }
        self.loggedOutRouting = nil
        detachChild(loggedOutRouting)
        viewController.uiviewController.dismiss(animated: true)
    }
}
