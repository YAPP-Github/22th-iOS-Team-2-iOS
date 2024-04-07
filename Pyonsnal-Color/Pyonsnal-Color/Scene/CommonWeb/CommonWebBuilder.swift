//
//  CommonWebBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebDependency: Dependency {
    
}

final class CommonWebComponent: Component<CommonWebDependency> {
    var subTerms: SubTerms?
    var settingInfo: SettingInfo?
    var userEventDetail: UserEventDetail?
    
    init(dependency: CommonWebDependency,
         subTerms: SubTerms?,
         settingInfo: SettingInfo?,
         userEventDetail: UserEventDetail?
    ) {
        self.subTerms = subTerms
        self.settingInfo = settingInfo
        self.userEventDetail = userEventDetail
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CommonWebBuildable: Buildable {
    //termsOfUse
    func build(withListener listener: CommonWebListener, subTerms: SubTerms) -> CommonWebRouting
    //profile
    func build(withListener listener: CommonWebListener, settingInfo: SettingInfo) -> CommonWebRouting
    //userEvent
    func build(withListener listener: CommonWebListener, userEventDetail: UserEventDetail) -> CommonWebRouting
}

final class CommonWebBuilder: Builder<CommonWebDependency>, CommonWebBuildable {
    
    override init(dependency: CommonWebDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: CommonWebListener, subTerms: SubTerms) -> CommonWebRouting {
        let component = CommonWebComponent(
            dependency: dependency,
            subTerms: subTerms,
            settingInfo: nil,
            userEventDetail: nil
        )
        let viewController = CommonWebViewController()
        let interactor = CommonWebInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return CommonWebRouter(interactor: interactor,
                               viewController: viewController)
    }
    
    func build(withListener listener: CommonWebListener, settingInfo: SettingInfo) -> CommonWebRouting {
        let component = CommonWebComponent(
            dependency: dependency,
            subTerms: nil,
            settingInfo: settingInfo,
            userEventDetail: nil
        )
        let viewController = CommonWebViewController()
        let interactor = CommonWebInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return CommonWebRouter(interactor: interactor,
                               viewController: viewController)
    }
    
    func build(
        withListener listener: CommonWebListener,
        userEventDetail: UserEventDetail
    ) -> CommonWebRouting {
        let component = CommonWebComponent(
            dependency: dependency,
            subTerms: nil,
            settingInfo: nil,
            userEventDetail: userEventDetail
        )
        let viewController = CommonWebViewController()
        let interactor = CommonWebInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return CommonWebRouter(interactor: interactor, viewController: viewController)
    }
}
