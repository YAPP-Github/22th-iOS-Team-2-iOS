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
    func updateFilter(with filters: FilterDataEntity)
    func didFinishPaging()
    func updateFilterItems(with items: [FilterItemEntity])
    func updateSortFilter(type: FilterItemEntity)
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
    private var brandProducts: [ConvenienceStore: [BrandProductEntity]] = [:]
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
                self?.brandProducts[store] = productPage.content
                if let products = self?.brandProducts[store] {
                    self?.presenter.updateProducts(with: products, at: store)
                }
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
                self?.brandProducts[store]? += productPage.content
                if let products = self?.brandProducts[store] {
                    self?.presenter.updateProducts(with: products, at: store)
                    self?.presenter.didFinishPaging()
                }
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
    
    func updateFilterSelectedState(with filter: FilterItemEntity) -> FilterDataEntity? {
        filterDataEntity?.data.forEach { filters in
            filters.filterItem.forEach {
                var filterItem = $0
                if filterItem.code == filter.code {
                    filterItem = filter
                }
            }
        }
        return filterDataEntity
    }
    
    func needToShowRefreshCell() -> Bool {
        // sort를 제외한 나머지 filter에서 isSelected = true인 값이 있다면 return true
        let filterItemEntities = filterDataEntity?.data.filter { $0.filterType != .sort }
        guard let filterItemEntities else { return false }
        var needToShowRefreshCell: Bool = false
        filterItemEntities.forEach { filterItems in
            let notAllSelected = filterItems.filterItem.allSatisfy({ $0.isSelected == false })
            if !notAllSelected { // 선택 되어 있는게 한개라도 있다면
                needToShowRefreshCell = true
            }
        }
        return needToShowRefreshCell
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
    
    func didScrollToNextPage(store: ConvenienceStore) {
        if let lastPage = storeLastPages[store] {
            requestProducts(pageNumber: lastPage + 1, store: store, filterList: [])
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
    
    func applyFilterItems(_ items: [FilterItemEntity]) {
        // TODO: 적용된 필터로 상품 목록 조회하기
        router?.detachProductFilter()
        presenter.updateFilterItems(with: items)
    }
    
    func applySortFilter(type: FilterItemEntity) {
        // TODO: 적용된 필터로 상품 목록 조회하기
        router?.detachProductFilter()
        presenter.updateSortFilter(type: type)
    }
}
