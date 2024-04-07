//
//  ProfileEditInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import UIKit
import Combine
import ModernRIBs

protocol ProfileEditRouting: ViewableRouting {}

protocol ProfileEditPresentable: Presentable {
    var listener: ProfileEditPresentableListener? { get set }
    func loadInfo(with memberInfo: MemberInfoEntity?)
    func updateNicknameStatus(status: NetworkErrorType)
}

protocol ProfileEditListener: AnyObject {
    func detachProfileEditView()
}

final class ProfileEditInteractor: PresentableInteractor<ProfileEditPresentable>,
                                   ProfileEditInteractable,
                                   ProfileEditPresentableListener {

    weak var router: ProfileEditRouting?
    weak var listener: ProfileEditListener?
    private var cancellable = Set<AnyCancellable>()
    private var component: ProfileEditComponent?
    private var editProfileImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    private var userNameValidStateSubject = CurrentValueSubject<NetworkErrorType, Never>(.invalidBlankNickname)
    
    var isEditButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isNicknameValid(), isChangedProfileImage())
            .map { isNicknameValid, profileImageEdited in
                return (isNicknameValid || profileImageEdited)
            }.eraseToAnyPublisher()
    }
    
    init(presenter: ProfileEditPresentable, component: ProfileEditComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.loadInfo(with: component?.memberInfo)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapEditButton(with nickname: String, profileImage: UIImage?) {
        let nicknameEntity = getNicknameEntity(nickname: nickname)
        let imageData = profileImage?.jpegData(compressionQuality: 1)
        component?.dependency.memberAPIService
            .editProfile(
                nicknameEntity: nicknameEntity,
                imageData: imageData
            ){ [weak self] in
                self?.listener?.detachProfileEditView()
            } 
    }
    
    func didTapBackButton() {
        listener?.detachProfileEditView()
    }
    
    private func getNicknameEntity(nickname: String) -> NicknameEntity? {
        if let previousNickname = component?.memberInfo.nickname,
           previousNickname != nickname {
            return NicknameEntity(nickname: nickname)
        }
        return nil
    }
    
    func isChangedProfileImage() -> AnyPublisher<Bool, Never> {
        return editProfileImageSubject
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    func isNicknameValid() -> AnyPublisher<Bool, Never> {
        return userNameValidStateSubject
            .map { $0 == .validNickname }
            .eraseToAnyPublisher()
    }
    
    func editNickname(nickname: String?) {
        guard let nickname, !nickname.isEmpty else { 
            self.userNameValidStateSubject.send(.invalidBlankNickname)
            return
        }
        component?.dependency.memberAPIService
            .validate(nickname: nickname)
            .sink { [weak self] response in
                guard let self else { return }
                var resultType: NetworkErrorType?
                if let error = response.error {
                    if isNicknameStatus(errorType: error.type) {
                        resultType = error.type
                        if error.type == .emptyResponse { resultType = .validNickname }
                    }
                } else {
                    resultType = .validNickname
                }
                guard let resultType else { return }
                self.userNameValidStateSubject.send(resultType)
                self.presenter.updateNicknameStatus(status: resultType)
            }.store(in: &cancellable)
    }
    
    func editProfileImage(image: UIImage?) {
        editProfileImageSubject.send(image)
    }
    
    private func isNicknameStatus(errorType: NetworkErrorType) -> Bool {
        let nicknameResponseType: [NetworkErrorType] = [
            .invalidBlankNickname,
            .invalidParameter,
            .nicknameAlreadyExist,
            .emptyResponse
        ]
        return !nicknameResponseType.map { $0 == errorType }.isEmpty
    }
}
