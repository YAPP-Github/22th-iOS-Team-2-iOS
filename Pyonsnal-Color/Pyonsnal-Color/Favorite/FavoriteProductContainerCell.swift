//
//  FavoriteProductContainerCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/13.
//

import UIKit

enum FavoriteButtonAction {
    case add
    case delete
}

protocol FavoriteProductContainerCellDelegate: AnyObject {
    func didTapFavoriteButton(productId: String, action: FavoriteButtonAction)
}

final class FavoriteProductContainerCell: UICollectionViewCell {
    
    // MARK: - Interfaces
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    
    enum SectionType {
        case product
        case empty
    }
    
    enum ItemType: Hashable {
        case product(product: BrandProductEntity)
        case empty
    }
    
    weak var delegate: FavoriteProductContainerCellDelegate?
    
    // MARK: - Private Property
    private let viewHolder = ViewHolder()
    private(set) var dataSource: DataSource?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        registerCell()
        configureCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    func update(with data: [BrandProductEntity]?) {
        makeSnapshot(with: data)
    }
    
    // MARK: - Private Method
    private func registerCell() {
        viewHolder.collectionView.register(ProductCell.self)
        viewHolder.collectionView.register(EmptyCell.self)
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.setCollectionViewLayout(
            self.createLayout(),
            animated: true
        )
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: viewHolder.collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .empty:
                let cell: EmptyCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setText(
                    titleText: EmptyCell.Text.Favorite.titleLabelText,
                    subTitleText: EmptyCell.Text.Favorite.subTitleLableText
                )
                return cell
            case .product(let product):
                let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateCell(with: product)
                cell.setFavoriteButton(isVisible: true)
                cell.setFavoriteButtonSelected(isSelected: true)
                cell.delegate = self
                return cell
            }
        }
    }
    
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
    
    private func makeSnapshot(with data: [BrandProductEntity]?) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        
        if let data, !data.isEmpty {
            let products = data.map { product in
                return ItemType.product(product: product)
            }
            snapshot.appendSections([.product])
            snapshot.appendItems(products, toSection: .product)
        } else {
            snapshot.appendSections([.empty])
            snapshot.appendItems([.empty], toSection: .empty)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    final class ViewHolder: ViewHolderable {
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: layout
            )
            return collectionView
        }()
        
        func place(in view: UIView) {
            view.addSubview(collectionView)
        }
        
        func configureConstraints(for view: UIView) {
            collectionView.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
    }
}

extension FavoriteProductContainerCell: ProductCellDelegate {
    func didTapFavoriteButton(productId: String, action: FavoriteButtonAction) {
        delegate?.didTapFavoriteButton(productId: productId, action: action)
    }
    
}
