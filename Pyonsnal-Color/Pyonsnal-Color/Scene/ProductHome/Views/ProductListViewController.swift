//
//  ProductListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    
    enum Constant {
        enum Size {
            static let productCellHeight: CGFloat = 235
            static let headerViewHeight: CGFloat = 22
            static let spacingCount: CGFloat = 3
            static let columnCount: CGFloat = 2
        }
    }
    
    enum ProductSectionType {
        case empty, item
    }
    
    enum SectionType: Hashable {
        case keywordFilter
        case product(type: ProductSectionType)
    }
    
    enum ItemType: Hashable {
        case keywordFilter(data: FilterItemEntity)
        case item(data: ProductDetailEntity?)
    }
    
    // MARK: - Private Property
    private(set) var dataSource: DataSource?
    weak var scrollDelegate: ScrollDelegate?
    weak var listDelegate: ProductListDelegate?
    weak var delegate: ProductListDelegate?
    private let refreshControl: UIRefreshControl = .init()
    let convenienceStore: ConvenienceStore
        
    // MARK: - View Component
    lazy var productCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray100
        return collectionView
    }()
    
    init(convenienceStore: ConvenienceStore) {
        self.convenienceStore = convenienceStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureCollectionView()
        delegate?.didLoadPageList(store: convenienceStore)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate?.didAppearProductList()
    }
    
    // MARK: - Private Method
    private func configureLayout() {
        view.addSubview(productCollectionView)
        
        productCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

    private func configureCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.backgroundColor = .gray100
        
        registerCells()
        configureDataSource()
        configureHeaderView()
        configureRefreshControl()
    }
    
    private func registerCells() {
        productCollectionView.register(KeywordFilterCell.self)
        productCollectionView.register(ProductCell.self)
        productCollectionView.register(EmptyProductCell.self)
        productCollectionView.register(ItemHeaderTitleView.self,
                                forSupplementaryViewOfKind: ItemHeaderTitleView.className,
                                withReuseIdentifier: ItemHeaderTitleView.className)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: productCollectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .keywordFilter(let keywordFilter):
                let cell: KeywordFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.configure(with: keywordFilter)
                return cell
            case .item(let brandProduct):
                if brandProduct == nil {
                    let cell: EmptyProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.delegate = self
                    return cell
                } else {
                    let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateCell(with: brandProduct)
                    cell.delegate = self
                    return cell
                }
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
            if section == .product(type: .item) {
                let itemTitle = "\(convenienceStore.convenienceStoreCellName) \(CommonConstants.productSectionHeaderTitle)"
                itemHeaderTitleView?.update(title: itemTitle)
            } else {
                return nil
            }
            return itemHeaderTitleView
        default:
            return nil
        }
    }
        
    private func configureRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(refreshByPull),
            for: .valueChanged
        )
        productCollectionView.refreshControl = refreshControl
    }
    
    func applySnapshot(with products: [ProductDetailEntity]?) {
        productCollectionView.isScrollEnabled = true
        let itemSectionType = SectionType.product(type: .item)
        guard var snapshot = dataSource?.snapshot(), let products else { return }
        
        let productItems = products.map { product in
            return ItemType.item(data: product)
        }
        
        snapshot.appendItems(productItems, toSection: itemSectionType)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func updateSnapshot(with products: [ProductDetailEntity]?) {
        productCollectionView.isScrollEnabled = true
        let itemSectionType = SectionType.product(type: .item)
        let emtpySectionType = SectionType.product(type: .empty)
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        
        guard let products, !products.isEmpty else { // 필터링 된 상품이 없을 경우 EmptyProductCell만 보여준다.
            productCollectionView.isScrollEnabled = false
            snapshot.appendSections([emtpySectionType])
            snapshot.appendItems([ItemType.item(data: nil)], toSection: emtpySectionType)
            dataSource?.apply(snapshot, animatingDifferences: true)
            return
        }
        
        // append product
        let productItems = products.map { product in
            return ItemType.item(data: product)
        }
        snapshot.appendSections([itemSectionType])
        
        if !productItems.isEmpty {
            snapshot.appendItems(productItems, toSection: itemSectionType)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.delegate?.didFinishUpdateSnapshot()
        }
    }
    
    func applyKeywordFilterSnapshot(with keywordItems: [FilterItemEntity]?) {
        guard var snapshot = dataSource?.snapshot() else { return }
        
        // TO DO : section delete 하지 않고 추가하는 방법
        snapshot.deleteSections([.keywordFilter])
        // append keywordFilter
        if let keywordItems,
           !keywordItems.isEmpty {
            let productSection: SectionType = .product(type: .item)
            let emtptySection: SectionType = .product(type: .empty)
            if !snapshot.sectionIdentifiers.isEmpty {
                let beforeSection: SectionType = snapshot.sectionIdentifiers.contains(productSection) ? productSection : emtptySection
                snapshot.insertSections([.keywordFilter], beforeSection: beforeSection)
            } else {
                snapshot.appendSections([.keywordFilter])
            }
            let items = keywordItems.map {
                return ItemType.keywordFilter(data: $0)
            }
            snapshot.appendItems(items, toSection: .keywordFilter)
        }
        scrollCollectionViewToTop()
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollCollectionViewToTop() {
        productCollectionView.setContentOffset(
            .init(x: 0, y: 0),
            animated: false
        )
    }
    
    // MARK: - Objective Method
    @objc
    private func refreshByPull() {
        productCollectionView.refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.refreshByPull()
            self.productCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource?.itemIdentifier(for: indexPath), case let .item(product) = item {
            logging(.itemClick, parameter: [
                .productName: product?.name ?? ""
            ])
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

// MARK: - KeywordFilterCellDelegate
extension ProductListViewController: KeywordFilterCellDelegate {
    func didTapDeleteButton(filter: FilterItemEntity) {
        delegate?.deleteKeywordFilter(filter)
    }
}

// MARK: - EmptyProductCellDelegate
extension ProductListViewController: EmptyProductCellDelegate {
    func didTapRefreshFilterButton() {
        delegate?.refreshFilterButton()
    }
}

// MARK: - ProductCellDelegate
extension ProductListViewController: ProductCellDelegate {
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        switch action {
        case .add:
            logging(.like, parameter: [
                .productName: product.name
            ])
        case .delete:
            logging(.unlike, parameter: [
                .productName: product.name
            ])
        }
        delegate?.didTapFavoriteButton(product: product, action: action)
    }
}
