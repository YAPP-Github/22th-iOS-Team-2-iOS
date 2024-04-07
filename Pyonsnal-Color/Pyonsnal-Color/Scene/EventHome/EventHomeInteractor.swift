//
//  EventHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import Combine
import ModernRIBs

protocol EventHomeRouting: ViewableRouting {
    func attachProductSearch()
    func detachProductSearch()
    func attachEventDetail(with imageURL: String, store: ConvenienceStore)
    func detachEventDetail()
    func attachProductDetail(with brandProduct: ProductDetailEntity, filter: FilterEntity)
    func detachProductDetail()
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
    func attachLoginPopup()
    func detachLoginPopup()
    func attachLoggedOut()
    func detachLoggedOut(animated: Bool)
}

protocol EventHomePresentable: Presentable {
    var listener: EventHomePresentableListener? { get set }
    
    func updateProducts(with products: [ProductDetailEntity], at store: ConvenienceStore)
    func update(with products: [ProductDetailEntity], banners: [EventBannerEntity], filterDataEntity: FilterDataEntity?, at store: ConvenienceStore)
    func updateFilter()
    func didStartPaging()
    func didFinishPaging()
    func requestInitialProduct()
}

protocol EventHomeListener: AnyObject {
    func routeToLoggedIn()
}

final class EventHomeInteractor:
    PresentableInteractor<EventHomePresentable>,
    EventHomeInteractable,
    EventHomePresentableListener {
    
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

    weak var router: EventHomeRouting?
    weak var listener: EventHomeListener?
    
    private let dependency: EventHomeDependency
    var filterStateManager: FilterStateManager?
    
    private var cancellable = Set<AnyCancellable>()
    private let initialPage: Int = 0
    private let initialCount: Int = 20
    private let productPerPage: Int = 20
    private var storeLastPages: [ConvenienceStore: Int] = [:]
    private var storeTotalPages: [ConvenienceStore: Int] = [:]
    
    init(
        presenter: EventHomePresentable,
        dependency: EventHomeDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore, filterList: [Int]) {
        storeLastPages[store] = pageNumber
        dependency.productAPIService.requestEventProduct(
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
    
    private func requestProductWithBanners(store: ConvenienceStore, filterList: [Int]) {
        storeLastPages[store] = initialPage
        let eventPublisher = dependency.productAPIService.requestEventBanner(storeType: store)
        let productPublisher = dependency.productAPIService.requestEventProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store,
            filterList: filterList
        )
        
        eventPublisher
            .combineLatest(productPublisher)
            .sink { [weak self] event, product in
                self?.storeTotalPages[store] = product.value?.totalPages
                
                if let event = event.value,
                   let product = product.value?.content {
                    self?.presenter.update(
                        with: product,
                        banners: event,
                        filterDataEntity: self?.filterDataEntity,
                        at: store
                    )
                    self?.presenter.didFinishPaging()
            }
        }.store(in: &cancellable)
    }
    
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        if let isGuest = UserInfoService.shared.isGuest, isGuest {
            router?.attachLoginPopup()
        } else {
            switch action {
            case .add:
                addFavorite(with: product)
            case .delete:
                deleteFavorite(with: product)
            }
        }
    }
    
    private func addFavorite(with product: ProductDetailEntity) {
        dependency.favoriteAPIService.addFavorite(
            productId: product.id,
            productType: product.productType
            ).sink { [weak self] response in
                // nothing
            }.store(in: &cancellable)
        }
        
    private func deleteFavorite(with product: ProductDetailEntity) {
        dependency.favoriteAPIService.deleteFavorite(
            productId: product.id,
            productType: product.productType
        ).sink { [weak self] response in
            // nothing
        }.store(in: &cancellable)
    }
    
    private func requestFilter() {
        dependency.productAPIService.requestFilter()
            .sink { [weak self] response in
                if let filter = response.value {
                    // 이벤트 탭에서는 상품 추천 filterType 제외
                    let filters = filter.data.filter { $0.filterType != .recommend }
                    let filterDataEntity = FilterDataEntity(data: filters)
                    self?.filterStateManager = FilterStateManager(filterDataEntity: filterDataEntity)
                    self?.presenter.updateFilter()
                }
            }.store(in: &cancellable)
    }
    
    func didTapSearchButton() {
        router?.attachProductSearch()
    }
    
    func popProductSearch() {
        router?.detachProductSearch()
    }
    
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        router?.attachEventDetail(with: imageURL, store: store)
    }
    
    func didTapBackButton() {
        router?.detachEventDetail()
    }
    
    func didLoadEventHome() {
        if let store = ConvenienceStore.allCases.first {
            requestProductWithBanners(store: store, filterList: [])
        }
        requestFilter()
    }
    
    func didScrollToNextPage(store: ConvenienceStore, filterList: [Int]) {
        if let lastPage = storeLastPages[store], let totalPage = storeTotalPages[store] {
            let nextPage = lastPage + 1
            
            if nextPage < totalPage {
                presenter.didStartPaging()
                requestProducts(pageNumber: nextPage, store: store, filterList: filterList)
            }
        }
    }
    
    func didSelect(with brandProduct: ProductDetailEntity) {
        router?.attachProductDetail(
            with: brandProduct,
            filter: .init(
                filterType: .unknown,
                defaultText: "리뷰 정렬",
                filterItem: [
                    .init(name: "최신순", code: 0, image: nil),
                    .init(name: "좋아요순", code: 0, image: nil)
                ]
            )
        )
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func didTapRefreshFilterCell() {
        self.resetFilterState()
        ConvenienceStore.allCases.forEach { store in
            requestProductWithBanners(store: store, filterList: selectedFilterCodeList)
        }
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestProductWithBanners(store: store, filterList: selectedFilterCodeList)
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
        let filterCodeList = [item.code]
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
        filterStateManager?.appendFilterCodeList(filterCodeList, type: .sort)
        filterStateManager?.updateSortFilterState(for: item)
        filterStateManager?.setSortFilterDefaultText()
        self.requestwithUpdatedKeywordFilter()
    }
    
    func requestwithUpdatedKeywordFilter() {
        presenter.requestInitialProduct()
        // 전체 편의점 데이터를 다 업데이트 한다.
        ConvenienceStore.allCases.forEach { store in
            requestProductWithBanners(store: store, filterList: selectedFilterCodeList)
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
    
    func popupDidTapDismiss() {
        router?.detachLoginPopup()
    }
    
    func popupDidTapConfirm() {
        router?.detachLoginPopup()
        router?.attachLoggedOut()
    }
    
    func routeToLoggedIn() {
        router?.detachLoggedOut(animated: false)
        listener?.routeToLoggedIn()
    }
    
    func detachLoggedOut() {
        router?.detachLoggedOut(animated: true)
    }
}
