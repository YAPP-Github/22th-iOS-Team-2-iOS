//
//  EventHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import UIKit
import ModernRIBs
import SnapKit

protocol EventHomePresentableListener: AnyObject, FilterRenderable {
    func didLoadEventHome()
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore)
    func didTapSearchButton()
    func didChangeStore(to store: ConvenienceStore)
    func didScrollToNextPage(store: ConvenienceStore, filterList: [Int])
    func didSelect(with brandProduct: ProductDetailEntity)
    func didSelectFilter(_ filterEntity: FilterEntity?)
    func didTapRefreshFilterCell()
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction)
}

final class EventHomeViewController: UIViewController,
                                     EventHomePresentable,
                                     EventHomeViewControllable {
    
    enum Header {
        static let title = "행사 상품 모아보기"
    }
    
    enum TabBarItem {
        static let title = "행사 상품"
    }
    
    // MARK: - Interfaces
    weak var listener: EventHomePresentableListener?
    typealias StoreDataSource = TopCollectionViewDatasource.StoreDataSource
    typealias StoreSection = TopCollectionViewDatasource.SectionType
    typealias StoreItem = TopCollectionViewDatasource.ItemType
    
    typealias FilterDataSource = TopCollectionViewDatasource.FilterDataSource
    typealias FilterSection = TopCollectionViewDatasource.FilterSection
    typealias FilterItem = TopCollectionViewDatasource.FilterItem
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var storeDataSource: StoreDataSource?
    private var filterDataSource: FilterDataSource?
    private var innerScrollLastOffsetY: CGFloat = 0
    private let convenienceStores: [String] = CommonConstants.convenienceStore
    private var initIndex: Int = 0
    private var isPaging: Bool = false
    private var isRequestingInitialProducts: Bool = false
    private var currentConvenienceStore: ConvenienceStore?
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureNavigationView()
        configureCollectionView()
        configureFilterCollectionView()
        configureDataSource()
        initialSnapshot()
        setPageViewController()
        setScrollView()
        configureUI()
        loadFirstEventProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "main_event"
        ])
    }
    
    // MARK: - Private method
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func loadFirstEventProducts() {
        if let firstConvenienceStore = ConvenienceStore.allCases
            .first(where: { $0.convenienceStoreCellName == convenienceStores.first }) {
            listener?.didLoadEventHome()
        }
    }
    
    private func configureDataSource() {
        configureStoreDatasource()
        configureFilterDataSource()
    }
    
    private func configureStoreDatasource() {
        storeDataSource = StoreDataSource(collectionView: viewHolder.collectionView)
        { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case let .convenienceStore(storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initIndex { // 초기 상태 selected
                    self.setSelectedConvenienceStoreCell(with: indexPath)
                }
                return cell
            }
        }
    }
    
    private func configureFilterDataSource() {
        filterDataSource = FilterDataSource(
            collectionView: viewHolder.filterCollectionView
        ) { collectionView, index, item -> UICollectionViewCell? in
            switch item {
            case let .filter(filterItem):
                switch filterItem.filterUseType {
                case .refresh:
                    let cell: RefreshFilterCell = collectionView.dequeueReusableCell(for: index)
                    cell.delegate = self
                    return cell
                case .category:
                    let cell: CategoryFilterCell = collectionView.dequeueReusableCell(for: index)
                    cell.configure(filter: filterItem.filter)
                    return cell
                }
            }
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<StoreSection, StoreItem>()
        snapshot.appendSections([.convenienceStore(store: convenienceStores)])
        let items = convenienceStores.map { storeName in
            return StoreItem.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items)
        
        storeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyFilterSnapshot(with filters: FilterDataEntity?) {
        guard let filters else { return }
        var snapshot = NSDiffableDataSourceSnapshot<FilterSection, FilterItem>()
        
        if !filters.data.isEmpty {
            snapshot.appendSections([.filter])
            
            if listener?.isNeedToShowRefreshFilterCell ?? false {
                let refreshItem = FilterCellItem(filterUseType: .refresh, filter: nil)
                let refreshItems = [FilterItem.filter(filterItem: refreshItem)]
                snapshot.appendItems(refreshItems)
            }
            
            let filterItems = filters.data.map { filter in
                let filterItem = FilterCellItem(filter: filter)
                return FilterItem.filter(filterItem: filterItem)
            }
            snapshot.appendItems(filterItems)
        }
        
        filterDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createStoreLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifiers = self?.storeDataSource?.snapshot().sectionIdentifiers[index] else {
                return nil
            }
            
            if case let .convenienceStore(stores) = sectionIdentifiers {
                let layout = TopCommonSectionLayout()
                return layout.convenienceStoreLayout(convenienceStore: stores)
            }
            return nil
        }
    }
    
    private func createFilterLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifiers = self?.storeDataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = TopCommonSectionLayout()
            return layout.filterLayout()
        }
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ConvenienceStoreCell.self)
        viewHolder.collectionView.collectionViewLayout = createStoreLayout()
    }
    
    private func configureFilterCollectionView() {
        viewHolder.filterCollectionView.delegate = self
        viewHolder.filterCollectionView.register(CategoryFilterCell.self)
        viewHolder.filterCollectionView.register(RefreshFilterCell.self)
        viewHolder.filterCollectionView.collectionViewLayout = createFilterLayout()
    }
    
    private func setPageViewController() {
        addChild(viewHolder.pageViewController)
        viewHolder.pageViewController.didMove(toParent: self)
        viewHolder.pageViewController.pageDelegate = self
        viewHolder.pageViewController.scrollDelegate = self
    }
    
    private func setScrollView() {
        viewHolder.containerScrollView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func setupTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: TabBarItem.title,
            image: ImageAssetKind.TabBar.eventUnselected.image,
            selectedImage: ImageAssetKind.TabBar.eventSelected.image
        )
    }
    
    private func setSelectedConvenienceStoreCell(with indexPath: IndexPath) {
        viewHolder.collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .init()
        )
    }
    
    func updateProducts(with products: [ProductDetailEntity], at store: ConvenienceStore) {
        if let storeIndex = convenienceStores.firstIndex(of: store.convenienceStoreCellName) {
            let tabViewController = viewHolder.pageViewController.pageViewControllers[storeIndex]
            tabViewController.applyEventProductsSnapshot(with: products)
        }
    }
    
    func update(
        with products: [ProductDetailEntity],
        banners: [EventBannerEntity],
        filterDataEntity: FilterDataEntity?,
        at store: ConvenienceStore
    ) {
        if let storeIndex = convenienceStores.firstIndex(of: store.convenienceStoreCellName) {
            self.currentConvenienceStore = store
            let tabViewController = viewHolder.pageViewController.pageViewControllers[storeIndex]
            tabViewController.applyEventBannerProducts(with: banners, products: products)
            applyFilterSnapshot(with: filterDataEntity)
            let filterKeywordList = listener?.selectedFilterKeywordList
            tabViewController.applyKeywordFilterSnapshot(with: filterKeywordList)
        }
    }
    
    func updateFilter() {
        listener?.initializeFilterState()
        let filter = listener?.filterDataEntity
        applyFilterSnapshot(with: filter)
    }
    
    func didStartPaging() {
        isPaging = true
    }
    
    func didFinishPaging() {
        isPaging = false
    }
    
    func requestInitialProduct() {
        isRequestingInitialProducts = true
    }
    
    func currentTabViewController() -> EventHomeTabViewController? {
        guard let currentViewController = viewHolder.pageViewController.viewControllers?.first,
              let currentTabViewController = currentViewController as? EventHomeTabViewController else {
            return nil
        }
        return currentTabViewController
    }
}

// MARK: - EventHomePageViewControllerDelegate
extension EventHomeViewController: EventHomePageViewControllerDelegate {
    
    func didTapRefreshFilterButton() {
        didTapRefreshButton()
    }
    
    func didSelect(with brandProduct: ProductDetailEntity) {
        listener?.didSelect(with: brandProduct)
    }
    
    func updateSelectedStoreCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        setSelectedConvenienceStoreCell(with: indexPath)
        currentConvenienceStore = currentTabViewController()?.convenienceStore
    }
    
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        
        var gaParameterKey: GAParameterKey
        switch store {
        case .cu:
            gaParameterKey = .cuEventName
        case .gs25:
            gaParameterKey = .gsEventName
        case .emart24:
            gaParameterKey = .emartEventName
        case .sevenEleven:
            gaParameterKey = .sevenEventName
        }
        logging(.eventClick, parameter: [
            gaParameterKey: imageURL
        ])
        listener?.didTapEventBannerCell(with: imageURL, store: store)
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        listener?.didChangeStore(to: store)
    }
    
    func deleteKeywordFilter(_ filter: FilterItemEntity) {
        listener?.deleteKeywordFilter(filter)
    }
    
    func didFinishUpdateSnapshot() {
        isRequestingInitialProducts = false
    }
    
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        listener?.didTapFavoriteButton(product: product, action: action)
    }
}

extension EventHomeViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
    }
}

// MARK: - UICollectionViewDelegate
extension EventHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.collectionView {
            var storeName: String?
            switch indexPath.item {
            case 0:
                storeName = "cu"
            case 1:
                storeName = "gs25"
            case 2:
                storeName = "emart24"
            case 3:
                storeName = "7eleven"
            default:
                storeName = nil
            }
            logging(.navbarClick, parameter: [
                .eventNavName: storeName ?? "nil"
            ])
            guard let selectedItem = storeDataSource?.itemIdentifier(for: indexPath) else { return }
            
            if case .convenienceStore(_) = selectedItem {
                currentConvenienceStore = currentTabViewController()?.convenienceStore
                viewHolder.pageViewController.updatePage(indexPath.item)
            }
        } else if collectionView == viewHolder.filterCollectionView {
            guard let selectedItem = filterDataSource?.itemIdentifier(for: indexPath) else { return }
            
            if case let .filter(filterItem) = selectedItem {
                listener?.didSelectFilter(filterItem.filter)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension EventHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tabViewController = currentTabViewController() else { return }
        
        let collectionView = tabViewController.collectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let swipeDirectionY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let downScroll = swipeDirectionY < 0
        let upScroll = swipeDirectionY > 0
        let outerScrollMaxOffset: CGFloat = CommonProduct.Size.titleNavigationBarHeight
        
        if innerScroll && upScroll {
            // 안쪽을 위로 스크롤할때 바깥쪽 스크롤뷰의 contentOffset을 0으로 줄이기
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            // 스크롤뷰의 contentOffset을 내림
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        let paginationHeight = abs(collectionView.contentSize.height - collectionView.bounds.height) * 0.9
        
        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y && !isRequestingInitialProducts {
            let filterList = listener?.selectedFilterCodeList ?? []
            listener?.didScrollToNextPage(
                store: tabViewController.convenienceStore,
                filterList: filterList
            )
        }
        
        if innerScroll && downScroll {
            // 안쪽을 아래로 스크롤할때 바깥쪽 먼저 아래로 스크롤
            guard viewHolder.containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
            
            let scrolledHeight = scrollView.contentOffset.y - innerScrollLastOffsetY
            let minOffsetY = min(
                viewHolder.containerScrollView.contentOffset.y + scrolledHeight,
                outerScrollMaxOffset
            )
            let offsetY = max(minOffsetY, 0)
            
            viewHolder.containerScrollView.contentOffset.y = offsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != viewHolder.containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != viewHolder.containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
        }
    }
}

// MARK: - ScrollDelegate
extension EventHomeViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    func willBeginDragging(scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView)
    }
    
    func didEndDragging(scrollView: UIScrollView) {
        self.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
}

// MARK: - ProductPresentable
extension EventHomeViewController: ProductPresentable {
    func didTabRootTabBar() {
        guard let tabViewController = currentTabViewController() else {
            return
        }
        
        tabViewController.scrollCollectionViewToTop()
    }
    
}

// MARK: - RefreshFilterCellDelegate
extension EventHomeViewController: RefreshFilterCellDelegate {
    func didTapRefreshButton() {
        listener?.didTapRefreshFilterCell()
    }
}
