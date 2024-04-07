//
//  ProductSearchInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import Foundation
import ModernRIBs
import Combine

protocol ProductSearchRouting: ViewableRouting {
    func attachSortBottomSheet(with filterItem: FilterItemEntity)
    func detachSortBottomSheet()
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
    func attachProductDetail(with product: ProductDetailEntity)
    func detachProductDetail()
    func attachLoginPopup()
    func detachLoginPopup()
    func attachLoggedOut()
    func detachLoggedOut(animated: Bool)
}

protocol ProductSearchPresentable: Presentable {
    var listener: ProductSearchPresentableListener? { get set }
    
    func presentProducts(with items: [ProductCellType], isCanLoading: Bool, totalCount: Int, filterItem: FilterItemEntity)
}

protocol ProductSearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popProductSearch()
    func routeToLoggedIn()
}

final class ProductSearchInteractor: PresentableInteractor<ProductSearchPresentable>, ProductSearchInteractable, ProductSearchPresentableListener {

    weak var router: ProductSearchRouting?
    weak var listener: ProductSearchListener?
    
    // MARK: - Private Property
    private let dependency: ProductSearchDependency
    private var cancellable = Set<AnyCancellable>()
    private(set) var keyword: String?
    private var filterEntity: FilterEntity?
    private var filterItem: FilterItemEntity?
    private var pageNumber: Int = 0
    private let pageSize: Int = 20
    private var isCanLoading: Bool = false
    private var totalCount: Int = 0
    private var eventProductResult: [ProductDetailEntity] = [] {
        didSet {
            guard let filterItem else { return }
            if eventProductResult.isEmpty {
                presenter.presentProducts(
                    with: [.empty],
                    isCanLoading: isCanLoading,
                    totalCount: totalCount,
                    filterItem: filterItem
                )
            } else {
                let items: [ProductCellType] = eventProductResult.map { .item($0) }
                presenter.presentProducts(
                    with: items,
                    isCanLoading: isCanLoading,
                    totalCount: totalCount,
                    filterItem: filterItem
                )
            }
        }
    }

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: ProductSearchPresentable,
        dependency: ProductSearchDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        requestFilters()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didSelectProduct(with indexPath: IndexPath) {
        if eventProductResult.count > indexPath.item {
            let product = eventProductResult[indexPath.item]
            logging(.itemClick, parameter: [
                .searchProductName: product.name
            ])
            router?.attachProductDetail(with: product)
        }
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func popViewController() {
        listener?.popProductSearch()
    }
    
    func search(with keyword: String?) {
        self.keyword = keyword
        self.pageNumber = 0
        self.filterItem = filterEntity?.filterItem.first
        
        guard let filterItem else { return }
        if let keyword,
           !keyword.isEmpty {
            logging(.keywordSearch, parameter: [
                .searchKeyword: keyword
            ])
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword,
                sortedCode: filterItem.code
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    let isLastPage = productPage.isLast
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.totalCount = productPage.content.count
                    self?.eventProductResult = productPage.content
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(
                with: [.empty],
                isCanLoading: false,
                totalCount: 0,
                filterItem: filterItem
            )
        }
    }
    
    func loadMoreItems() {
        guard let filterItem else { return }
        if let keyword,
           !keyword.isEmpty {
            pageNumber += 1
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword,
                sortedCode: filterItem.code
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    var currentProducts = self?.eventProductResult ?? []
                    let isLastPage = productPage.isLast
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.totalCount = productPage.content.count
                    currentProducts += productPage.content
                    self?.eventProductResult = currentProducts
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(
                with: [.empty],
                isCanLoading: false,
                totalCount: 0,
                filterItem: filterItem
            )
        }
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
    
    private func requestFilters() {
        dependency.productAPIService.requestFilter()
            .sink { [weak self] response in
                if let filter = response.value {
                    let filterEntity = filter.data.filter { $0.filterType == .sort }.first
                    self?.filterEntity = filterEntity
                    if let firstItem = filterEntity?.filterItem.first {
                        self?.filterItem = .init(name: firstItem.name, code: firstItem.code, image: firstItem.image, isSelected: true)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    private func requestSort(filterItem: FilterItemEntity) {
        self.pageNumber = 0
        self.filterItem = filterItem
        
        if let keyword,
           !keyword.isEmpty {
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword,
                sortedCode: filterItem.code
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    let isLastPage = productPage.isLast
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.totalCount = productPage.content.count
                    self?.eventProductResult = productPage.content
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(
                with: [.empty],
                isCanLoading: false,
                totalCount: 0,
                filterItem: filterItem
            )
        }
    }
    
    func setSort(sort: FilterItemEntity) {
    }
    
    func didTapSortButton(filterItem: FilterItemEntity) {
        guard var filterItems = filterEntity?.filterItem else { return }
        filterItems = filterItems.map { .init(name: $0.name, code: $0.code, image: $0.image, isSelected: false) }
        if let index = filterItems.firstIndex(where: { item in
            return item.code == filterItem.code
        }) {
            let targetItem = filterItems[index]
            filterItems[index] = .init(
                name: targetItem.name,
                code: targetItem.code,
                image: nil,
                isSelected: true
            )
        }
        
        let filterEntity: FilterEntity = .init(
            filterType: .sort,
            defaultText: "정렬 선택",
            filterItem: filterItems
        )
        router?.attachProductFilter(of: filterEntity)
    }
    
    func productFilterDidTapCloseButton() {
        router?.detachProductFilter()
    }
    
    func applyFilterItems(_ items: [FilterItemEntity], type: FilterType) {
        
    }
    
    func applySortFilter(item: FilterItemEntity) {
        logging(.sortFilterClick, parameter: [
            .searchSortFilterName: item.name
        ])
        requestSort(filterItem: item)
        router?.detachProductFilter()
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
