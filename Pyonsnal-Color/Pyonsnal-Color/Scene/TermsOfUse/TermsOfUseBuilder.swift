//
//  TermsOfUseBuilder.swift
//  Pyonsnal-Color
// 
//  Created by 조소정 on 2023/07/06.
//

import ModernRIBs

protocol TermsOfUseDependency: Dependency {
    
}

final class TermsOfUseComponent: Component<TermsOfUseDependency>,
                                 CommonWebDependency {

}

// MARK: - Builder

protocol TermsOfUseBuildable: Buildable {
    func build(withListener listener: TermsOfUseListener) -> TermsOfUseRouting
}

final class TermsOfUseBuilder: Builder<TermsOfUseDependency>, TermsOfUseBuildable {
    

    override init(dependency: TermsOfUseDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TermsOfUseListener) -> TermsOfUseRouting {
        let component = TermsOfUseComponent(dependency: dependency)
        let viewController = TermsOfUseViewController()
        let commonWebBuilder = CommonWebBuilder(dependency: component)
        let interactor = TermsOfUseInteractor(presenter: viewController)
        interactor.listener = listener
        return TermsOfUseRouter(interactor: interactor, viewController: viewController, commonWebBuilder: commonWebBuilder)
    }
}
