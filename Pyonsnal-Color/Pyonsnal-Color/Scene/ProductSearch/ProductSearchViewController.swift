//
//  ProductSearchViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs
import UIKit
import Combine

enum ProductCellType: Hashable {
    case empty
    case item(ProductDetailEntity)
}

protocol ProductSearchPresentableListener: AnyObject {
    var keyword: String? { get }
    func popViewController()
    func search(with keyword: String?)
    func loadMoreItems()
    func setSort(sort: FilterItemEntity)
    func didTapSortButton(filterItem: FilterItemEntity)
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction)
    func didSelectProduct(with indexPath: IndexPath)
}

final class ProductSearchViewController: UIViewController,
                                         ProductSearchPresentable,
                                         ProductSearchViewControllable {
    // MARK: - Declaration
    enum Size {
        static let collectionViewLineSpacing: CGFloat = 12
        static let collectionViewItemSpacing: CGFloat = 12
        static let collectionViewEdgeInset: UIEdgeInsets = .init(
            top: 16, left: 16, bottom: 40, right: 16
        )
        static let collectionViewHeaderHeight: CGFloat = 50
        static let collectionViewLoadingFooterHeight: CGFloat = 50
    }
    
    struct Section: Hashable {
        let id = UUID()
        let totalCount: Int
        let filterItem: FilterItemEntity
    }
    
    weak var listener: ProductSearchPresentableListener?
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductCellType>?
    private let textSubject = PassthroughSubject<String?, Never>()
    private var cancellable = Set<AnyCancellable>()
    private var isCanLoading: Bool = false
    private var isEmpty: Bool = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureUI()
        configureAction()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "search"
        ])
    }
    
    // MARK: - Private Method
    private func bind() {
        textSubject
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] text in
                self?.listener?.search(with: text)
            }
            .store(in: &cancellable)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureCollectionView()
    }
    
    private func configureAction() {
        viewHolder.backButton.addTarget(
            self,
            action: #selector(backButtonAction(_:)),
            for: .touchUpInside
        )
        viewHolder.searchBarView.delegate = self
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ProductCell.self)
        viewHolder.collectionView.register(EmptyCell.self)
        viewHolder.collectionView.registerHeaderView(SearchFilterHeader.self)
        viewHolder.collectionView.registerFooterView(LoadingReusableView.self)
        
        dataSource = .init(
            collectionView: viewHolder.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .empty:
                    let cell: EmptyCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.setText(
                        titleText: EmptyCell.Text.Search.titleLabelText,
                        subTitleText: EmptyCell.Text.Search.subtitleLabelText
                    )
                    return cell
                case let .item(product):
                    let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateCell(with: product)
                    cell.delegate = self
                    return cell
                }
            }
        )
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: .init(describing: SearchFilterHeader.self),
                    for: indexPath
                ) as? SearchFilterHeader else {
                    return UICollectionReusableView()
                }
                if let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] {
                    header.updateUI(
                        payload: .init(totalCount: section.totalCount, filterItem: section.filterItem)
                    )
                    header.delegate = self
                }
                return header
            case UICollectionView.elementKindSectionFooter:
                let loading = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: LoadingReusableView.self),
                    for: indexPath
                )
                return loading
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    func presentProducts(
        with items: [ProductCellType],
        isCanLoading: Bool,
        totalCount: Int,
        filterItem: FilterItemEntity
    ) {
        self.isEmpty = items.first == .empty
        self.isCanLoading = isCanLoading
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductCellType>()
        snapshot.appendSections([.init(totalCount: totalCount, filterItem: filterItem)])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }
    
    @objc private func backButtonAction(_ sender: UIButton) {
        listener?.popViewController()
    }
}

extension ProductSearchViewController: SearchBarViewDelegate {
    func updateText(_ text: String?) {
        textSubject.send(text)
    }
}

extension ProductSearchViewController: SearchFilterHeaderDelegate {
    func didTapSortButton(filterItem: FilterItemEntity) {
        listener?.didTapSortButton(filterItem: filterItem)
    }
}

extension ProductSearchViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.didSelectProduct(with: indexPath)
        view.endEditing(true)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            listener?.loadMoreItems()
        }
    }
}

extension ProductSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        if !isEmpty {
            return .init(
                width: collectionView.bounds.width,
                height: Size.collectionViewHeaderHeight
            )
        } else {
            return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        if isCanLoading {
            return .init(
                width: collectionView.bounds.width,
                height: Size.collectionViewLoadingFooterHeight
            )
        } else {
            return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if isEmpty {
            return collectionView.bounds.size
        } else {
            let itemSpacing = Size.collectionViewItemSpacing
            let edgeInsetLeft = Size.collectionViewEdgeInset.left
            let edgeInsetRight = Size.collectionViewEdgeInset.right
            let spacing = itemSpacing + edgeInsetLeft + edgeInsetRight
            let collectionViewWidth = collectionView.bounds.width
            let cellHeightRatio: CGFloat = 1.35
            
            let cellWidth = (collectionViewWidth - spacing) / 2
            let cellHeight: CGFloat = 235
            
            return .init(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        if isEmpty {
            return .zero
        } else {
            return Size.collectionViewItemSpacing
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        if isEmpty {
            return .zero
        } else {
            return Size.collectionViewLineSpacing
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if isEmpty {
            return .zero
        } else {
            return Size.collectionViewEdgeInset
        }
    }
}

// MARK: - ProductCellDelegate
extension ProductSearchViewController: ProductCellDelegate {
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        switch action {
        case .add:
            logging(.like, parameter: [
                .searchProductName: product.name
            ])
        case .delete:
            logging(.unlike, parameter: [
                .searchProductName: product.name
            ])
        }
        listener?.didTapFavoriteButton(product: product, action: action)
    }
}
