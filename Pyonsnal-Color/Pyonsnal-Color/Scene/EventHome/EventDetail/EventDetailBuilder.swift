//
//  EventDetailBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs

protocol EventDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EventDetailComponent: Component<EventDetailDependency>, CommonWebDependency {
    var imageURL: String
    var store: ConvenienceStore?
    var eventDetail: EventBannerDetailEntity?
    
    init(
        imageURL: String,
        store: ConvenienceStore? = nil,
        eventDetail: EventBannerDetailEntity? = nil,
        dependency: EventDetailDependency
    ) {
        self.imageURL = imageURL
        self.store = store
        self.eventDetail = eventDetail
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(
        withListener listener: EventDetailListener,
        imageURL: String,
        store: ConvenienceStore
    ) -> EventDetailRouting
    
    func build(
        withListener listener: EventDetailListener,
        eventDetail: EventBannerDetailEntity
    ) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {

    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: EventDetailListener,
        imageURL: String,
        store: ConvenienceStore
    ) -> EventDetailRouting {
        let component = EventDetailComponent(
            imageURL: imageURL,
            store: store,
            dependency: dependency
        )
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(
            presenter: viewController,
            component: component
        )
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
    
    func build(
        withListener listener: EventDetailListener,
        eventDetail: EventBannerDetailEntity
    ) -> EventDetailRouting {
        let component = EventDetailComponent(
            imageURL: eventDetail.detailImage,
            eventDetail: eventDetail,
            dependency: dependency
        )
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(
            presenter: viewController,
            component: component
        )
        let commonWebBuilder = CommonWebBuilder(dependency: component)
        interactor.listener = listener
        return EventDetailRouter(
            interactor: interactor,
            viewController: viewController,
            commonWebBuilder: commonWebBuilder
        )
    }
}
