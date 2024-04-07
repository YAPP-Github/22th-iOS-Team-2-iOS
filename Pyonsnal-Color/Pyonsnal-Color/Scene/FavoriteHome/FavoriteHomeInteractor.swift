//
//  FavoriteHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs
import Combine
import Foundation

protocol FavoriteHomeRouting: ViewableRouting {
    func attachProductSearch()
    func detachProductSearch()
    func attachProductDetail(with product: ProductDetailEntity)
    func detachProductDetail()
}

protocol FavoriteHomePresentable: Presentable {
    var listener: FavoriteHomePresentableListener? { get set }
    func updateProducts(products: [ProductDetailEntity]?, tab: FavoriteHomeTab)
}

protocol FavoriteHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FavoriteHomeInteractor: PresentableInteractor<FavoriteHomePresentable>,
                                    FavoriteHomeInteractable,
                                    FavoriteHomePresentableListener {
    // MARK: - Interfaces
    weak var router: FavoriteHomeRouting?
    weak var listener: FavoriteHomeListener?
    
    // MARK: - Private Proverty
    private let favoriteAPIService: FavoriteAPIService
    private var cancellable = Set<AnyCancellable>()
    
    private var pbPageNumber: Int = 0
    private var eventPageNumber: Int = 0
    private let pageSize: Int = 20
    private var deletedProducts = [ProductDetailEntity]()
    
    private var isPbPagingEnabled: Bool = true
    private var isEventPagingEnabled: Bool = true
    var isPagingEnabled: Bool {
        return isPbPagingEnabled && isEventPagingEnabled
    }
    private var isPbPagingNumberLoadMore: Bool = true
    private var isEventPagingNumberLoadMore: Bool = true
    
    private var productDictionary: [FavoriteHomeTab: [ProductDetailEntity]] = [:]
    
    // MARK: - Initializer
    init(
        presenter: FavoriteHomePresentable,
        favoriteAPIService: FavoriteAPIService
    ) {
        self.favoriteAPIService = favoriteAPIService
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // pb, event 찜하기 상품 조회
    func requestFavoriteProducts() {
        self.requestPbProducts()
        self.requestEventProducts()
    }
    
    func appendProduct(product: ProductDetailEntity) {
        if let index = deletedProducts.firstIndex(where: { $0.id == product.id }) {
            deletedProducts.remove(at: index)
        }
    }
    
    func deleteProduct(product: ProductDetailEntity) {
        deletedProducts.append(product)
    }
    
    func deleteAllProducts() {
        let group = DispatchGroup()
        for product in self.deletedProducts {
            group.enter()
            self.favoriteAPIService.deleteFavorite(
                productId: product.id,
                productType: product.productType
            ).sink { _ in
                group.leave()
            }.store(in: &self.cancellable)
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.deletedProducts = []
            self?.requestFavoriteProducts()
        }
    }
    
    func didTapSearchButton() {
        router?.attachProductSearch()
    }
    
    func popProductSearch() {
        router?.detachProductSearch()
    }
    
    func didSelect(with product: ProductDetailEntity) {
        router?.attachProductDetail(with: product)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    private func requestPbProducts() {
        self.isPbPagingEnabled = false
        self.pbPageNumber = 0
        favoriteAPIService.favorites(
            pageNumber: pbPageNumber,
            pageSize: pageSize,
            productType: .pb
        ).sink { [weak self] response in
            guard let self else { return }
            if let product = response.value {
                self.isPbPagingNumberLoadMore = !product.isLast
                self.productDictionary[.product] = product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.product],
                    tab: .product
                )
            } else {
                // TODO: Error Handling
            }
            self.isPbPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    private func loadMorePbProducts() { // for pagination
        self.isPbPagingEnabled = false
        if !self.isPbPagingNumberLoadMore {
            self.isPbPagingEnabled = true
            return
        }
        self.pbPageNumber += 1
        
        favoriteAPIService.favorites(
            pageNumber: pbPageNumber,
            pageSize: pageSize,
            productType: .pb
        ).sink { [weak self] response in
            guard let self else { return }
            if let product = response.value {
                self.isPbPagingNumberLoadMore = !product.isLast
                self.productDictionary[.product]? += product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.product],
                    tab: .product
                )
            } else {
                // TODO: Error Handling
            }
            self.isPbPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    private func requestEventProducts() {
        self.isEventPagingEnabled = false
        self.eventPageNumber = 0
        favoriteAPIService.favorites(
            pageNumber: eventPageNumber,
            pageSize: pageSize,
            productType: .event
        ).sink { [weak self] response in
            guard let self else { return }
            if let product = response.value {
                self.isEventPagingNumberLoadMore = !product.isLast
                self.productDictionary[.event] = product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.event],
                    tab: .event
                )
            } else {
                // TODO: Error Handling
            }
            self.isEventPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    private func loadMoreEventProducts() { // for pagination
        self.isEventPagingEnabled = false
        if !self.isEventPagingNumberLoadMore { 
            self.isEventPagingEnabled = true
            return
        }
        self.eventPageNumber += 1
        favoriteAPIService.favorites(
            pageNumber: eventPageNumber,
            pageSize: pageSize,
            productType: .event
        ).sink { [weak self] response in
            guard let self else { return }
            if let product = response.value {
                self.isEventPagingNumberLoadMore = !product.isLast
                self.productDictionary[.event]? += product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.event],
                    tab: .event
                )
            } else {
                // TODO: Error Handling
            }
            self.isEventPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    func loadMoreItems(type: ProductType) {
        if !isPagingEnabled { return }
        switch type {
        case .pb:
            self.loadMorePbProducts()
        case .event:
            self.loadMoreEventProducts()
        }
    }
    
    func routeToLoggedIn() {
    }
}
