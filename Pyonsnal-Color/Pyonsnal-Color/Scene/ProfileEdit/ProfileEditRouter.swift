//
//  ProfileEditRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import ModernRIBs

protocol ProfileEditInteractable: Interactable {
    var router: ProfileEditRouting? { get set }
    var listener: ProfileEditListener? { get set }
}

protocol ProfileEditViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileEditRouter: ViewableRouter<ProfileEditInteractable, ProfileEditViewControllable>, ProfileEditRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileEditInteractable, viewController: ProfileEditViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
