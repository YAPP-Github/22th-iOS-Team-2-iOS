//
//  ProfileEditBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import ModernRIBs

protocol ProfileEditDependency: Dependency {
    var memberAPIService: MemberAPIService { get }
}

final class ProfileEditComponent: Component<ProfileEditDependency> {
    var memberInfo: MemberInfoEntity
    init(dependency: ProfileEditDependency, memberInfo: MemberInfoEntity) {
        self.memberInfo = memberInfo
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ProfileEditBuildable: Buildable {
    func build(withListener listener: ProfileEditListener, memberInfo: MemberInfoEntity) -> ProfileEditRouting
}

final class ProfileEditBuilder: Builder<ProfileEditDependency>, ProfileEditBuildable {

    override init(dependency: ProfileEditDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: ProfileEditListener,
        memberInfo: MemberInfoEntity
    ) -> ProfileEditRouting {
        let component = ProfileEditComponent(dependency: dependency, memberInfo: memberInfo)
        let viewController = ProfileEditViewController()
        let interactor = ProfileEditInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return ProfileEditRouter(interactor: interactor, viewController: viewController)
    }
}
