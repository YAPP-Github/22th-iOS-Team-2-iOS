//
//  ProductHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import Combine
import ModernRIBs

protocol ProductHomeRouting: ViewableRouting {
    func attachProductSearch()
    func detachProductSearch()
    func attachNotificationList()
    func detachNotificationList()
    func attachProductDetail(with brandProduct: ProductConvertable)
    func detachProductDetail()
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
}

protocol ProductHomePresentable: Presentable {
    var listener: ProductHomePresentableListener? { get set }
    
    func updateProducts(with products: [ConvenienceStore: [BrandProductEntity]])
    func updateProducts(with products: [BrandProductEntity], at store: ConvenienceStore)
    func replaceProducts(with products: [BrandProductEntity], at store: ConvenienceStore)
    func updateFilter(with filters: FilterDataEntity)
    func didStartPaging()
    func didFinishPaging()
    func requestInitialProduct()
    func updateCuration(with products: [CurationEntity])
    func updateFilterItems(with items: [FilterItemEntity], type: FilterType)
    func updateSortFilter(item: FilterItemEntity)
}

protocol ProductHomeListener: AnyObject {
}

final class ProductHomeInteractor:
    PresentableInteractor<ProductHomePresentable>,
    ProductHomeInteractable,
    ProductHomePresentableListener {

    weak var router: ProductHomeRouting?
    weak var listener: ProductHomeListener?
    
    private var dependency: ProductHomeDependency?
    private var cancellable = Set<AnyCancellable>()
    private let initialPage: Int = 0
    private let initialCount: Int = 20
    private let productPerPage: Int = 20
    private var storeLastPages: [ConvenienceStore: Int] = [:]
    private var storeTotalPages: [ConvenienceStore: Int] = [:]
    private var filterEntity: [FilterEntity] = []

    init(
        presenter: ProductHomePresentable,
        dependency: ProductHomeDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        requestInitialProducts(filterList: [])
		requestCurationProducts()
        requestFilter()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func requestInitialProducts(store: ConvenienceStore = .all, filterList: [String]) {
        storeLastPages[store] = initialPage
        
        dependency?.productAPIService.requestBrandProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store,
            filterList: filterList
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.storeTotalPages[store] = productPage.totalPages
                self?.presenter.replaceProducts(with: productPage.content, at: store)
            } else if response.error != nil {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore, filterList: [String]) {
        storeLastPages[store] = pageNumber
        dependency?.productAPIService.requestBrandProduct(
            pageNumber: pageNumber,
            pageSize: productPerPage,
            storeType: store,
            filterList: filterList
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.presenter.updateProducts(with: productPage.content, at: store)
                self?.presenter.didFinishPaging()
            }
        }.store(in: &cancellable)
    }
    
    private func requestFilter() {
        dependency?.productAPIService.requestFilter()
            .sink { [weak self] response in
            if let filter = response.value {
                self?.presenter.updateFilter(with: filter)
            }
        }.store(in: &cancellable)
    }
    
    private func requestCurationProducts() {
        dependency?.productAPIService.requestCuration().sink { [weak self] response in
            if let curationPage = response.value {
                self?.presenter.updateCuration(with: curationPage.curationProducts)
            } else if response.error != nil {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    func didTapSearchButton() {
        router?.attachProductSearch()
    }
    
    func popProductSearch() {
        router?.detachProductSearch()
    }
    
    func didTapNotificationButton() {
        router?.attachNotificationList()
    }
    
    func notificationListDidTapBackButton() {
        router?.detachNotificationList()
    }
    
    func didScrollToNextPage(store: ConvenienceStore, filterList: [String]) {
        if let lastPage = storeLastPages[store], let totalPage = storeTotalPages[store] {
            let nextPage = lastPage + 1
            
            if nextPage < totalPage {
                presenter.didStartPaging()
                requestProducts(pageNumber: nextPage, store: store, filterList: filterList)
            }
        }
    }
    
    func didSelect(with brandProduct: ProductConvertable?) {
        guard let brandProduct else { return }
        router?.attachProductDetail(with: brandProduct)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestInitialProducts(store: store, filterList: [])
    }
    
    func didTapRefreshFilterCell(with store: ConvenienceStore) {
        requestInitialProducts(store: store, filterList: [])
	}
    
    func didSelectFilter(ofType filterEntity: FilterEntity?) {
        guard let filterEntity else { return }
        
        router?.attachProductFilter(of: filterEntity)
    }
    
    func productFilterDidTapCloseButton() {
        router?.detachProductFilter()
    }
    
    func applyFilterItems(_ items: [FilterItemEntity], type: FilterType) {
        router?.detachProductFilter()
        presenter.updateFilterItems(with: items, type: type)
    }
    
    func applySortFilter(type: FilterItemEntity) {
        router?.detachProductFilter()
        presenter.updateSortFilter(item: type)
    }
    
    func requestwithUpdatedKeywordFilter(with store: ConvenienceStore, filterList: [String]) {
        presenter.requestInitialProduct()
        requestInitialProducts(store: store, filterList: filterList)
    }
    
}
