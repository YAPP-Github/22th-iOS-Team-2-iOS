//
//  ProfileHomeViewModel.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import Foundation
import Combine

// MARK: - Declaration
extension ProfileHomeViewModel {
    struct Dependency {
        let userAuthService: UserAuthService
        let memberAPIService: MemberAPIService
    }
    
    struct Payload {}
    
    enum Action {
        case didTapProfileEditButton
        case didSelectItem(item: ProfileHomeSettingItem)
    }
    
    struct Output {
        var profileImage = PassthroughSubject<ImageAssetKind, Never>()
        var memberInfo = PassthroughSubject<MemberInfoEntity, Never>()
    }
}

final class ProfileHomeViewModel: BaseViewModelProtocol {
    // MARK: - Property
    private let dependency: Dependency
    private let payload: Payload
    private let router: ProfileHomeRouter_R
    
    @Published private var memberInfo: MemberInfoEntity?
    @Published private var action: Action?
    let output: Output = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    let sections: [ProfileHomeSection] = [.setting]
    var settingItems: [ProfileHomeSettingItem] = [.etc, .email, .version, .teams, .account]
    let emailAddress = "pallete@pyonsnalcolor.store"
    
    
    init(dependency: Dependency, payload: Payload, router: ProfileHomeRouter_R) {
        self.dependency = dependency
        self.payload = payload
        self.router = router
        self.bindActions()
        self.requestMemberInfo()
    }
    
    func bindActions() {
        $action
            .sink { [weak self] action in
                guard let action else { return }
                self?.processAction(action)
            }
            .store(in: &cancellables)
        
        $memberInfo
            .sink { [weak self] memberInfo in
                guard let memberInfo else { return }
                if memberInfo.isGuest {
                    self?.setGuestMode()
                }
                self?.output.memberInfo.send(memberInfo)
            }.store(in: &cancellables)
    }
    
    func send(_ action: Action) {
        self.action = action
    }
    
    private func processAction(_ action: Action) {
        switch action {
        case .didTapProfileEditButton:
            self.didTapProfileEditButton()
        case .didSelectItem(let item):
            print()
            // TODO: logic port
        }
    }
    
    private func didTapProfileEditButton() {
        guard let memberInfo else { return }
        guard !memberInfo.isGuest else {
            // TODO: router (self.attachLoggedOut())
            return
        }
        // TODO: router (router?.attachProfileEdit(with: memberInfo))
    }
    
    func requestMemberInfo() {
        dependency.memberAPIService.info()
            .map { $0.value }
            .assign(to: &$memberInfo)
    }
    
    func setGuestMode() {
        settingItems.remove(at: ProfileHomeSettingItem.account.rawValue)
        output.profileImage.send(.iconDetail)
    }

}
