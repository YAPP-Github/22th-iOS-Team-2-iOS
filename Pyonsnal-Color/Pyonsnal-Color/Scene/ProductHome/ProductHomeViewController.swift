//
//  ProductHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol ProductHomePresentableListener: AnyObject, FilterRenderable {
    func didChangeStore(to store: ConvenienceStore)
    func didTapSearchButton()
    func didTapNotificationButton()
    func didScrollToNextPage(store: ConvenienceStore?, filterList: [Int])
    func didSelect(with brandProduct: ProductDetailEntity?)
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction)
    func didTapEventBanner(eventDetail: EventBannerDetailEntity)
}

final class ProductHomeViewController:
    UIViewController,
    ProductHomePresentable,
    ProductHomeViewControllable {
    
    // MARK: - Interface
    weak var listener: ProductHomePresentableListener?
    typealias StoreDataSource = TopCollectionViewDatasource.StoreDataSource
    typealias StoreSection = TopCollectionViewDatasource.SectionType
    typealias StoreItem = TopCollectionViewDatasource.ItemType
    
    typealias FilterDataSource = TopCollectionViewDatasource.FilterDataSource
    typealias FilterSection = TopCollectionViewDatasource.FilterSection
    typealias FilterItem = TopCollectionViewDatasource.FilterItem
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var storeDataSource: StoreDataSource?
    private var filterDataSource: FilterDataSource?
    private let convenienceStores: [String] = CommonConstants.productHomeStore
    private let initialIndex: Int = 0
    private var innerScrollLastOffsetY: CGFloat = 0
    private var isPaging: Bool = false
    private var isRequestingInitialProducts: Bool = false
    private var currentConvenienceStore: ConvenienceStore?
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureCollectionView()
        configureFilterCollectionView()
        configureDataSource()
        initialStoreSnapshot()
        configureProductCollectionView()
        configureNotificationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "main_home"
        ])
        
        hideFilterCollectionView()
    }
    
    // MARK: - Private Method
    private func configureDataSource() {
        configureStoreDatasource()
        configureFilterDataSource()
    }
    
    private func configureStoreDatasource() {
        storeDataSource = StoreDataSource(
            collectionView: viewHolder.collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case let .convenienceStore(storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initialIndex { // 초기 상태 selected
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
    
    private func initialStoreSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<StoreSection, StoreItem>()
        snapshot.appendSections([.convenienceStore(store: convenienceStores)])
        let items = convenienceStores.map { storeName in
            return StoreItem.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items, toSection: .convenienceStore(store: convenienceStores))
        
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
    
    private func setSelectedConvenienceStoreCell(with indexPath: IndexPath) {
        viewHolder.collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .init()
        )
    }
    
    private func setupViews() {
        let customFont: UIFont = .label2
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
        tabBarItem = UITabBarItem(
            title: "차별화 상품",
            image: ImageAssetKind.TabBar.homeUnselected.image,
            selectedImage: ImageAssetKind.TabBar.homeSelected.image
        )
        
        view.backgroundColor = .white
        viewHolder.containerScrollView.delegate = self
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
    
    private func configureProductCollectionView() {
        viewHolder.productHomePageViewController.pagingDelegate = self
        viewHolder.productHomePageViewController.scrollDelegate = self
    }
    
    private func requestProducts(store: ConvenienceStore) {
        listener?.didChangeStore(to: store)
    }
    
    private func configureNotificationButton() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func hideFilterCollectionView() {
        viewHolder.filterCollectionView.isHidden = true
    }
    
    private func showFilterCollectionView() {
        viewHolder.filterCollectionView.isHidden = false
    }
    
    func showNotificationList(_ viewController: ModernRIBs.ViewControllable) {
        let notificationListViewController = viewController.uiviewController
        
        notificationListViewController.modalPresentationStyle = .fullScreen
        present(notificationListViewController, animated: true)
    }
    
    func updateProducts(with products: [ConvenienceStore: [ProductDetailEntity]]) {
        guard let viewController = viewHolder.productHomePageViewController.viewControllers?.first,
              let productListViewController = viewController as? ProductListViewController
        else {
            return
        }
        
        if let products = products[productListViewController.convenienceStore] {
            productListViewController.applySnapshot(with: products)
        }
    }
    
    func updateProducts(with products: [ProductDetailEntity], at store: ConvenienceStore) {
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            self.currentConvenienceStore = store
            let pageViewController = viewHolder.productHomePageViewController
            let storeIndex = storeIndex + 1 // curation index
            if let viewController = pageViewController.productListViewControllers[storeIndex] as? ProductListViewController {
                viewController.applySnapshot(with: products)
            }
        }
    }
    
    func replaceProducts(
        with products: [ProductDetailEntity],
        filterDataEntity: FilterDataEntity?,
        at store: ConvenienceStore
    ) {
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            self.currentConvenienceStore = store
            let pageViewController = viewHolder.productHomePageViewController
            let storeIndex = storeIndex + 1
            if let viewController = pageViewController.productListViewControllers[storeIndex] as? ProductListViewController {
                viewController.updateSnapshot(with: products)
                applyFilterSnapshot(with: filterDataEntity)
                let filterKeywordList = listener?.selectedFilterKeywordList
                viewController.applyKeywordFilterSnapshot(with: filterKeywordList)
            }
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
    
    func updateHomeBanner(with items: [HomeBannerEntity]) {
        let pageViewController = viewHolder.productHomePageViewController
        if let viewController = pageViewController.productListViewControllers.first as? ProductCurationViewController {
            viewController.applySnapshot(with: items)
        }
    }
    
    func currentListViewController() -> ProductListViewController? {
        let pageViewController = viewHolder.productHomePageViewController.viewControllers?.first
        if let productListViewController = pageViewController as? ProductListViewController {
            return productListViewController
        }
        return nil
    }

}

// MARK: - TitleNavigationViewDelegate
extension ProductHomeViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
        listener?.didTapNotificationButton()
    }
}

// MARK: - UIScrollViewDelegate
extension ProductHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let productListViewController = currentListViewController() else { return }
        let collectionView = productListViewController.productCollectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let swipeDirectionY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let downScroll = swipeDirectionY < 0
        let upScroll = swipeDirectionY > 0
        let outerScrollMaxOffset = viewHolder.titleNavigationView.frame.height
        
        if innerScroll && upScroll {
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        let paginationHeight = abs(collectionView.contentSize.height - collectionView.bounds.height) * 0.9

        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y && !isRequestingInitialProducts {
            let filterList = listener?.selectedFilterCodeList ?? []
            listener?.didScrollToNextPage(
                store: productListViewController.convenienceStore,
                filterList: filterList
            )
        }
        
        if innerScroll && downScroll {
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

// MARK: - UICollectionViewDelegate
extension ProductHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.collectionView {
            guard let selectedItem = storeDataSource?.itemIdentifier(for: indexPath) else { return }
            
            switch selectedItem {
            case .convenienceStore:
                var storeName: String?
                switch indexPath.item {
                case 0:
                    storeName = "pick"
                case 1:
                    storeName = "cu"
                case 2:
                    storeName = "gs25"
                case 3:
                    storeName = "emart24"
                case 4:
                    storeName = "7eleven"
                default:
                    storeName = nil
                }
                logging(.navbarClick, parameter: [
                    .pbNavName: storeName ?? "nil"
                ])
                currentConvenienceStore = currentListViewController()?.convenienceStore
                viewHolder.productHomePageViewController.updatePage(to: indexPath.item)
                indexPath.item == 0 ? hideFilterCollectionView() : showFilterCollectionView()
            }
        } else if collectionView == viewHolder.filterCollectionView {
            guard let selectedItem = filterDataSource?.itemIdentifier(for: indexPath) else { return }
            
            if case let .filter(filterEntity) = selectedItem {
                listener?.didSelectFilter(filterEntity.filter)
            }
        } else {
            guard let productListViewController = viewHolder.productHomePageViewController.viewControllers?.first as? ProductListViewController,
                  let selectedItem = productListViewController.dataSource?.itemIdentifier(for: indexPath) else { return }
            
            switch selectedItem {
            case .item(let brandProduct):
                listener?.didSelect(with: brandProduct)
            default:
                break
            }
        }
    }
}

//MARK: - ScrollDelegate
extension ProductHomeViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView)
    }
    
    func willBeginDragging(scrollView: UIScrollView) {
        scrollViewWillBeginDragging(scrollView)
    }
    
    func didEndDragging(scrollView: UIScrollView) {
        scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
}

// MARK: - ProductHomePageViewControllerDelegate
extension ProductHomeViewController: ProductHomePageViewControllerDelegate {
    
    func didTapRefreshFilterButton() {
        didTapRefreshButton()
    }
    
    func updateSelectedStoreCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        setSelectedConvenienceStoreCell(with: indexPath)
        currentConvenienceStore = currentListViewController()?.convenienceStore
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        listener?.didChangeStore(to: store)
    }

    func deleteKeywordFilter(_ filter: FilterItemEntity) {
        listener?.deleteKeywordFilter(filter)
    }
    
    func didLoadPageList(store: ConvenienceStore) {
        requestProducts(store: store)
    }
    
    func refreshByPull() {
        guard let currentConvenienceStore else { return }
        requestProducts(store: currentConvenienceStore)
    }
    
    func didSelect(with brandProduct: ProductDetailEntity) {
        listener?.didSelect(with: brandProduct)
    }
    
    func didAppearProductList() {
        showFilterCollectionView()
    }
    
    func didFinishUpdateSnapshot() {
        isRequestingInitialProducts = false
    }
    
    func curationWillAppear() {
        hideFilterCollectionView()
    }
    
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        listener?.didTapFavoriteButton(product: product, action: action)
    }
    
    func didTapEventBanner(eventDetail: EventBannerDetailEntity) {
        listener?.didTapEventBanner(eventDetail: eventDetail)
    }
}

// MARK: - ProductPresentable
extension ProductHomeViewController: ProductPresentable {
    func didTabRootTabBar() {
        let viewController = viewHolder.productHomePageViewController.viewControllers?.first
        if let listViewController = viewController as? ProductListViewController {
            listViewController.scrollCollectionViewToTop()
        } else if let curationViewController = viewController as? ProductCurationViewController {
            curationViewController.scrollCollectionViewToTop()
        }
    }
}

// MARK: - listViewController
extension ProductHomeViewController: RefreshFilterCellDelegate {
    func didTapRefreshButton() {
        listener?.didTapRefreshFilterCell()
    }
}
