//
//  MyDetailReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs
import UIKit

protocol MyDetailReviewPresentableListener: AnyObject {
    func didTapBackButton()
}

final class MyDetailReviewViewController: UIViewController,
                                          MyDetailReviewPresentable,
                                          MyDetailReviewViewControllable {
    // MARK: Interfaces
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private enum Section {
        case main
    }
    
    private enum Item: Hashable {
        case productDetail(product: ProductDetailEntity)
        case review(review: ReviewEntity)
        case landing
    }
    
    weak var listener: MyDetailReviewPresentableListener?
    
    // MARK: Private Properties
    private let viewHolder: ViewHolder = .init()
    private var dataSource: DataSource?
    private var productDetail: ProductDetailEntity?
    private var review: ReviewEntity?
    
    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        self.configureUI()
        self.bindActions()
        self.configureCollectionView()
        self.configureDataSource()
        self.applySnapshot(with: productDetail, review: review)
    }
    
    func update(with productDetail: ProductDetailEntity, review: ReviewEntity) {
        self.productDetail = productDetail
        self.review = review
    }
    
    // MARK: Private Methods
    private func configureUI() {
        self.view.backgroundColor = .white
    }
    
    private func bindActions() {
        self.viewHolder.backNavigationView.delegate = self
    }
    
    private func configureCollectionView() {
        self.registerCollectionViewCells()
        self.viewHolder.collectionView.delegate = self
    }
    
    private func registerCollectionViewCells() {
        self.viewHolder.collectionView.register(ProductDetailReviewCell.self)
        self.viewHolder.collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: MyReviewContentView.identifier
        )
        self.viewHolder.collectionView.register(ActionButtonCell.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: self.viewHolder.collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .productDetail(let product):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewContentView.identifier, for: indexPath)
                cell.contentConfiguration = MyReviewContentConfiguration(
                    mode: .tastes,
                    storeImageIcon: product.storeType,
                    imageUrl: product.imageURL,
                    title: "프링글스) 매콤한맛(대) 프링글스) 매콤한맛(대)프링글스) 매콤한맛(대)프링글스) 매콤한맛",
                    tastesTag: ["카페인 러버", "헬창", "캐릭터컬렉터", "캐릭터컬렉터"]
                )
                return cell
            case .review(let review):
                let cell: ProductDetailReviewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.payload = .init(hasEvaluateView: false, review: review)
                return cell
            case .landing:
                let cell: ActionButtonCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.actionButton.setText(with: ActionButtonCell.Constants.Text.showProduct)
                return cell
            }
        }
    }
    
    private func applySnapshot(with productDetail: ProductDetailEntity?, review: ReviewEntity?) {
        guard let productDetail, let review else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.productDetail(product: productDetail)])
        snapshot.appendItems([.review(review: review)])
        snapshot.appendItems([.landing])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyDetailReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return CGSize.zero }
        let screenWidth = collectionView.bounds.width
        switch item {
        case .productDetail:
            return .init(width: screenWidth, height: 136)
        case .review(let review):
            let estimateHeight: CGFloat = 1000
            let cell = ProductDetailReviewCell()
            cell.frame = .init(
                origin: .zero,
                size: .init(width: screenWidth, height: estimateHeight)
            )
            cell.payload = .init(hasEvaluateView: false, review: review)
            cell.layoutIfNeeded()
            let estimateSize = cell.systemLayoutSizeFitting(
                .init(width: screenWidth, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )
            return estimateSize
        case .landing:
            return .init(width: screenWidth, height: 40)
        }
    }
}

// MARK: - BackNavigationViewDelegate
extension MyDetailReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
