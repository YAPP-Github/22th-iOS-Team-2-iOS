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
    func attachProductDetail(with brandProduct: ProductDetailEntity)
    func detachProductDetail()
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
}

protocol ProductHomePresentable: Presentable {
    var listener: ProductHomePresentableListener? { get set }
    
    func updateProducts(with products: [ProductDetailEntity], at store: ConvenienceStore)
    func updateProduct(with product: ProductDetailEntity)
    func replaceProducts(with products: [ProductDetailEntity], filterDataEntity: FilterDataEntity?, at store: ConvenienceStore)
    func updateFilter()
    func didStartPaging()
    func didFinishPaging()
    func requestInitialProduct()
    func updateCuration(with products: [CurationEntity])
}

protocol ProductHomeListener: AnyObject {
}

final class ProductHomeInteractor:
    PresentableInteractor<ProductHomePresentable>,
    ProductHomeInteractable,
    ProductHomePresentableListener {
    
    weak var router: ProductHomeRouting?
    weak var listener: ProductHomeListener?
    
    private let dependency: ProductHomeDependency
    var filterStateManager: FilterStateManager?
    
    private var cancellable = Set<AnyCancellable>()
    private let initialPage: Int = 0
    private let initialCount: Int = 20
    private let productPerPage: Int = 20
    private var storeLastPages: [ConvenienceStore: Int] = [:]
    private var storeTotalPages: [ConvenienceStore: Int] = [:]
    
    var filterDataEntity: FilterDataEntity? {
        return filterStateManager?.getFilterDataEntity()
    }
    
    var selectedFilterCodeList: [Int] {
        return filterStateManager?.getFilterList() ?? []
    }
    
    var selectedFilterKeywordList: [FilterItemEntity]? {
        return filterStateManager?.getSelectedKeywordFilterList()
    }
    
    var isNeedToShowRefreshFilterCell: Bool {
        let isResetFilterState = filterStateManager?.isFilterDataResetState() ?? false
        return !isResetFilterState
    }
    
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
		requestCurationProducts()
        requestFilter()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func requestInitialProducts(store: ConvenienceStore, filterList: [Int]) {
        storeLastPages[store] = initialPage
        
        dependency.productAPIService.requestBrandProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store,
            filterList: filterList
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.storeTotalPages[store] = productPage.totalPages
                self?.presenter.replaceProducts(
                    with: productPage.content,
                    filterDataEntity: self?.filterDataEntity,
                    at: store
                )
            } else if response.error != nil {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore, filterList: [Int]) {
        storeLastPages[store] = pageNumber
        dependency.productAPIService.requestBrandProduct(
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
        dependency.productAPIService.requestFilter()
            .sink { [weak self] response in
            if let filter = response.value {
                self?.filterStateManager = FilterStateManager(filterDataEntity: filter)
                self?.presenter.updateFilter()
            }
        }.store(in: &cancellable)
    }
    
    private func requestCurationProducts() {
        dependency.productAPIService.requestCuration()
            .sink { [weak self] response in
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
    
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        switch action {
        case .add:
            addFavorite(with: product)
        case .delete:
            deleteFavorite(with: product)
        }
    }
    
    private func addFavorite(with product: ProductDetailEntity) {
        dependency.favoriteAPIService.addFavorite(
            productId: product.id,
            productType: product.productType
            ).sink { [weak self] response in
                self?.presenter.updateProduct(with: product)
            }.store(in: &cancellable)
        }
        
    private func deleteFavorite(with product: ProductDetailEntity) {
        dependency.favoriteAPIService.deleteFavorite(
            productId: product.id,
            productType: product.productType
        ).sink { [weak self] response in
            self?.presenter.updateProduct(with: product)
        }.store(in: &cancellable)
    }
    
    func didTapNotificationButton() {
        router?.attachNotificationList()
    }
    
    func notificationListDidTapBackButton() {
        router?.detachNotificationList()
    }
    
    func didScrollToNextPage(store: ConvenienceStore?, filterList: [Int]) {
        guard let store else { return }
        if let lastPage = storeLastPages[store], let totalPage = storeTotalPages[store] {
            let nextPage = lastPage + 1
            
            if nextPage < totalPage {
                presenter.didStartPaging()
                requestProducts(pageNumber: nextPage, store: store, filterList: filterList)
            }
        }
    }
    
    func didSelect(with brandProduct: ProductDetailEntity?) {
        guard let brandProduct else { return }
        router?.attachProductDetail(with: brandProduct)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestInitialProducts(store: store, filterList: selectedFilterCodeList)
    }
    
    func didTapRefreshFilterCell() {
        self.resetFilterState()
        ConvenienceStore.allCases.forEach { store in
            requestInitialProducts(store: store, filterList: [])
        }
	}
    
    func didSelectFilter(_ filterEntity: FilterEntity?) {
        guard let filterEntity else { return }
        router?.attachProductFilter(of: filterEntity)
    }
    
    func productFilterDidTapCloseButton() {
        router?.detachProductFilter()
    }
    
    func applyFilterItems(_ items: [FilterItemEntity], type: FilterType) {
        router?.detachProductFilter()
        self.updateFiltersState(with: items, type: type)
        self.requestwithUpdatedKeywordFilter()
    }
    
    func applySortFilter(item: FilterItemEntity) {
        router?.detachProductFilter()
        var filterName: String?
        switch item.code {
        case 1:
            filterName = "recent"
        case 2:
            filterName = "view_count"
        case 3:
            filterName = "low_price"
        case 4:
            filterName = "high_price"
        default:
            filterName = nil
        }
        logging(.sortFilterClick, parameter: [
            .sortFilterName: filterName ?? "nil"
        ])
        let filterCodeList = [item.code]
        filterStateManager?.appendFilterCodeList(filterCodeList, type: .sort)
        filterStateManager?.updateSortFilterState(for: item)
        filterStateManager?.setSortFilterDefaultText()
        self.requestwithUpdatedKeywordFilter()
    }
    
    func requestwithUpdatedKeywordFilter() {
        presenter.requestInitialProduct()
        ConvenienceStore.allCases.forEach { store in
            requestInitialProducts(store: store, filterList: selectedFilterCodeList)
        }
    }
    
    func initializeFilterState() {
        filterStateManager?.setLastSortFilterSelected()
        filterStateManager?.setFilterDefatultText()
    }
    
    func updateFiltersState(with filters: [FilterItemEntity], type: FilterType) {
        let filterCodeList = filters.map { $0.code }
        filterStateManager?.appendFilterCodeList(filterCodeList, type: type)
        filterStateManager?.updateFiltersItemState(filters: filters, type: type)
    }
    
    func deleteKeywordFilter(_ filter: FilterItemEntity) {
        filterStateManager?.updateFilterItemState(target: filter, to: false)
        filterStateManager?.deleteFilterCodeList(filterCode: filter.code)
        self.requestwithUpdatedKeywordFilter()
    }
    
    func resetFilterState() {
        filterStateManager?.updateAllFilterItemState(to: false)
        filterStateManager?.deleteAllFilterList()
        filterStateManager?.setSortFilterDefaultText()
    }
}
