//
//  PersonalViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit
import SnapKit

protocol ScrollDelegate: AnyObject {
    func didScroll(scrollView: UIScrollView)
    func willBeginDragging(scrollView: UIScrollView)
    func didEndDragging(scrollView: UIScrollView)
}

protocol EventHomeTabViewControllerDelegate: AnyObject {
    func didTapEventBannerCell(with imageUrl: String, store: ConvenienceStore)
    func didTapFilterDeleteButton(with filter: FilterItemEntity)
    func refreshFilterButton()
}

final class EventHomeTabViewController: UIViewController {
    enum ItemSectionType {
        case empty, item
    }
    enum SectionType: Hashable {
        case keywordFilter
        case event
        case item(type: ItemSectionType)
    }
    
    enum ItemType: Hashable {
        case keywordFilter(FilterItemEntity)
        case event(data: [EventBannerEntity])
        case item(data: EventProductEntity?)
    }
    
    enum Size {
        static let topMargin: CGFloat = 20
    }
    
    weak var scrollDelegate: ScrollDelegate?
    weak var delegate: EventHomeTabViewControllerDelegate?
    weak var listDelegate: ProductListDelegate?
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        return collectionView
    }()
    
    // MARK: - Private property
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    private var dataSource: DataSource?
    private var eventUrls: [EventBannerEntity] = []
    private let refreshControl = UIRefreshControl()
    private var lastContentOffSetY: CGFloat = 0
    
    let convenienceStore: ConvenienceStore
    private var filterStateManager: FilterStateManager?
    
    // MARK: - Initializer
    init(convenienceStore: ConvenienceStore) {
        self.convenienceStore = convenienceStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureCollectionView()
        configureDatasource()
        configureHeaderView()
        listDelegate?.didLoadPageList(store: convenienceStore)
    }
    
    // MARK: - Private Method
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = CommonProductSectionLayout()
            return layout.section(at: sectionIdentifier)
        }
    }
    
    private func configureUI() {
        collectionView.backgroundColor = .gray100
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setFilterStateManager(with filterDataEntity: FilterDataEntity) {
        filterStateManager = FilterStateManager(filterDataEntity: filterDataEntity)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .gray100
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: Size.topMargin,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        registerCollectionViewCells()
        setRefreshControl()
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(ItemHeaderTitleView.self,
                                forSupplementaryViewOfKind: ItemHeaderTitleView.className,
                                withReuseIdentifier: ItemHeaderTitleView.className)
        collectionView.register(KeywordFilterCell.self)
        collectionView.register(EventBannerCell.self)
        collectionView.register(ProductCell.self)
        collectionView.register(EmptyProductCell.self)
    }
    
    private func setRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(pullToRefresh),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listDelegate?.refreshByPull()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureDatasource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .keywordFilter(let keywordFilter):
                let cell: KeywordFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.configure(with: keywordFilter)
                return cell
            case .item(let item):
                if item == nil {
                    let cell: EmptyProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.delegate = self
                    return cell
                } else {
                    let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateCell(with: item)
                    return cell
                }
            case .event(let item):
                let cell: EventBannerCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.update(item)
                cell.delegate = self
                return cell
            }
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = makeSupplementaryView
    }
    
    private func makeSupplementaryView(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        switch kind {
        case ItemHeaderTitleView.className:
            let itemHeaderTitleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: kind,
                for: indexPath
            ) as? ItemHeaderTitleView
            guard let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                return nil
            }
             
            if section == .event {
                itemHeaderTitleView?.update(title: CommonConstants.eventSectionHeaderTitle)
            } else if section == .item(type: .item) {
                let itemTitle = "\(convenienceStore.convenienceStoreCellName) \(CommonConstants.itemSectionHeaderTitle)"
                itemHeaderTitleView?.update(title: itemTitle)
            } else {
                return nil
            }
            return itemHeaderTitleView
        default:
            return nil
        }
    }
    
    // pagination시 apply
    func applyEventProductsSnapshot(with products: [EventProductEntity]) {
        guard var snapshot = dataSource?.snapshot() else { return }
        let itemSectionType = SectionType.item(type: .item)
        
        let eventProducts = products.map { ItemType.item(data: $0) }

        snapshot.appendItems(eventProducts, toSection: itemSectionType)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func applyEventBannerProducts(
        with eventBanners: [EventBannerEntity]?,
        products: [EventProductEntity]?
    ) {
        collectionView.isScrollEnabled = true
        let itemSectionType = SectionType.item(type: .item)
        let emtpySectionType = SectionType.item(type: .empty)
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        scrollCollectionViewToTop()
        
        guard let products, !products.isEmpty else { // 필터링 된 상품이 없을 경우 EmptyProductCell만 보여준다.
            collectionView.isScrollEnabled = false
            snapshot.appendSections([emtpySectionType])
            snapshot.appendItems([ItemType.item(data: nil)], toSection: emtpySectionType)
            dataSource?.apply(snapshot, animatingDifferences: true)
            return
        }
        
        // append eventBanners
        let eventBanners = eventBanners ?? []
        snapshot.appendSections([.event])
        if !eventBanners.isEmpty {
            snapshot.appendItems([ItemType.event(data: eventBanners)], toSection: .event)
        }
        
        // append eventProducts
        let eventProducts = products.map { product in
            return ItemType.item(data: product)
        }
        snapshot.appendSections([itemSectionType])
        snapshot.appendItems(eventProducts, toSection: itemSectionType)
        dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.listDelegate?.didFinishUpdateSnapshot()
        }
    }
    
    func applyKeywordFilterSnapshot(with keywordItems: [FilterItemEntity]) {
        guard var snapshot = dataSource?.snapshot() else { return }
        // TO DO : section delete하지 않고 추가하는 방법
        snapshot.deleteSections([.keywordFilter])
        // append keywordFilter
        if !keywordItems.isEmpty {
            let beforeSection: SectionType = snapshot.sectionIdentifiers.contains(.event) ? .event : .item(type: .empty)
            snapshot.insertSections([.keywordFilter], beforeSection: beforeSection)
            
            let items = keywordItems.map {
                return ItemType.keywordFilter($0)
            }
            snapshot.appendItems(items, toSection: .keywordFilter)
        }
        scrollCollectionViewToTop()
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollCollectionViewToTop() {
        collectionView.setContentOffset(
            .init(x: 0, y: Spacing.spacing16.negative.value),
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegate
extension EventHomeTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource?.itemIdentifier(for: indexPath),
           case let .item(product) = item {
            listDelegate?.didSelect(with: product)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.willBeginDragging(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.didEndDragging(scrollView: scrollView)
    }
}

// MARK: - EventBannerCellDelegate
extension EventHomeTabViewController: EventBannerCellDelegate {
    func didTapEventBannerCell(with imageUrl: String, store: ConvenienceStore) {
        delegate?.didTapEventBannerCell(with: imageUrl, store: store)
    }
}

// MARK: - KeywordFilterCellDelegate
extension EventHomeTabViewController: KeywordFilterCellDelegate {
    func didTapDeleteButton(filter: FilterItemEntity) {
        // 현재 선택된 filter에서 삭제
        delegate?.didTapFilterDeleteButton(with: filter)
    }
}

// MARK: - EmptyProductCellDelegate
extension EventHomeTabViewController: EmptyProductCellDelegate {
    func didTapRefreshFilterButton() {
        listDelegate?.refreshFilterButton()
    }
}

// MARK: - FilterStateManager
extension EventHomeTabViewController {
    func resetFilterItemState() {
        filterStateManager?.updateAllFilterItemState(to: false)
    }
    
    func needToShowRefreshCell() -> Bool {
        let isFilterDataResetState = filterStateManager?.isFilterDataResetState() ?? false
        return !isFilterDataResetState
    }
    
    func initializeFilterState() {
        filterStateManager?.setLastSortFilterSelected()
        filterStateManager?.setFilterDefatultText()
    }
    
    func getFilterDataEntity() -> FilterDataEntity? {
        return filterStateManager?.getFilterDataEntity()
    }
    
    func updateFilterState(with filter: FilterItemEntity, isSelected: Bool) {
        filterStateManager?.updateFilterItemState(target: filter, to: isSelected)
    }
    
    func updateFiltersState(with filters: [FilterItemEntity], type: FilterType) {
        filterStateManager?.updateFiltersItemState(filters: filters, type: type)
    }
    
    func updateSortFilterState(with filter: FilterItemEntity) {
        filterStateManager?.updateSortFilterState(for: filter)
    }
    
    func updateSortFilterDefaultText() {
        filterStateManager?.setSortFilterDefaultText()
    }
    
    func appendFilterList(with filter: [String], type: FilterType) {
        filterStateManager?.appendFilterCodeList(filter, type: type)
    }
    
    func getFilterList() -> [String] {
        return filterStateManager?.getFilterList() ?? []
    }
    
    func deleteFilterCode(at filterCode: String) {
        filterStateManager?.deleteFilterCodeList(filterCode: filterCode)
    }
    
    func deleteAllFilterCode() {
        filterStateManager?.deleteAllFilterList()
    }
    
    func getKeywordList() -> [FilterItemEntity] {
        filterStateManager?.getSelectedKeywordFilterList() ?? []
    }
}
