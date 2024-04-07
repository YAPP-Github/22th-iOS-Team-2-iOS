//
//  ProductDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit
import Combine
import ModernRIBs

protocol ProductDetailPresentableListener: AnyObject {
    func popViewController()
    func addFavorite()
    func deleteFavorite()
    func refresh()
    func reloadData(with productDetail: ProductDetailEntity)
    func writeButtonDidTap()
    func sortButtonDidTap()
    func reviewLikeButtonDidTap(review: ReviewEntity)
    func reviewHateButtonDidTap(review: ReviewEntity)
    func attachStarRatingReview()
}

final class ProductDetailViewController:
    UIViewController,
    ProductDetailPresentable,
    ProductDetailViewControllable
{
    // MARK: - Declaration
    enum Text {
        static let updateLabelTextPrefix: String = "업데이트"
    }
    
    // MARK: - Interface
    weak var listener: ProductDetailPresentableListener?
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var sections: [ProductDetailSectionModel]? {
        didSet {
            viewHolder.collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configure()
        configureAction()
        bindActions()
    }
    
    // MARK: - Public Method
    func setFavoriteState(isSelected: Bool?) {
        viewHolder.backNavigationView.setFavoriteButtonSelected(isSelected: isSelected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "items"
        ])
        
        listener?.refresh()
    }
    
    // MARK: - Private Method
    private func configure() {
        view.backgroundColor = .white
        viewHolder.backNavigationView.favoriteButton.isHidden = false
        viewHolder.collectionView.dataSource = self
        viewHolder.collectionView.delegate = self
    }
    
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
    }
    
    private func bindActions() {
        viewHolder.backNavigationView.favoriteButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else { return }
                let action: FavoriteButtonAction = self.viewHolder
                    .backNavigationView.getFavoriteButtonSelected() ? .delete : .add
                if action == .add {
                    self.listener?.addFavorite()
                } else if action == .delete {
                    self.listener?.deleteFavorite()
                }
            }.store(in: &cancellable)
        
        viewHolder.collectionView.refreshControl?.addTarget(
            self,
            action: #selector(refreshControlAction),
            for: .valueChanged
        )
    }
    
    @objc private func refreshControlAction() {
        listener?.refresh()
    }

    func reloadCollectionView(with sectionModels: [ProductDetailSectionModel]) {
        viewHolder.collectionView.refreshControl?.endRefreshing()  
        self.sections = sectionModels
    }
    
    func updateHeaderImage(storeIcon: ImageAssetKind.StoreIcon) {
        viewHolder.backNavigationView.payload = .init(
            mode: .image,
            title: nil,
            iconImageKind: storeIcon
        )
    }
}

extension ProductDetailViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.popViewController()
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections {
            return sections.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if let sections {
            return sections[section].items.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let sections else {
            return UICollectionViewCell()
        }
        let section = sections[indexPath.section]
        switch section.items[indexPath.item] {
        case let .image(imageURL):
            let imageCell: ProductDetailImageCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            imageCell.payload = .init(imageURL: imageURL)
            return imageCell
        case let .information(entity):
            let informationCell: ProductDetailInformationCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            informationCell.payload = .init(productDetail: entity)
            return informationCell
        case let .reviewWrite(score, reviewsCount, sortItem):
            let reviewWriteCell: ProductDetailReviewWriteCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            reviewWriteCell.payload = .init(
                score: score,
                reviewsCount: reviewsCount,
                sortItem: sortItem
            )
            reviewWriteCell.delegate = self
            return reviewWriteCell
        case let .review(entity):
            let reviewCell: ProductDetailReviewCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            reviewCell.payload = .init(review: entity)
            reviewCell.delegate = self
            return reviewCell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LineFooter.identifier,
                for: indexPath
            )
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let sections else {
            return .zero
        }
        let section = sections[indexPath.section]
        let screenWidth = collectionView.bounds.width
        switch section.items[indexPath.item] {
        case .image:
            return .init(width: screenWidth, height: 320)
        case let .information(entity):
            let estimateHeight: CGFloat = 400
            let cell = ProductDetailInformationCell()
            cell.payload = .init(productDetail: entity)
            cell.frame = .init(
                origin: .zero,
                size: .init(width: screenWidth, height: estimateHeight)
            )
            cell.layoutIfNeeded()
            let estimateSize = cell.systemLayoutSizeFitting(
                .init(width: screenWidth, height: estimateHeight)
            )
            return .init(width: screenWidth, height: estimateSize.height)
        case .reviewWrite:
            return .init(width: screenWidth, height: 300)
        case let .review(entity):
            let width = collectionView.bounds.size.width
            let estimateHeight: CGFloat = 1000
            let cell = ProductDetailReviewCell()
            cell.frame = .init(
                origin: .zero,
                size: .init(width: width, height: estimateHeight)
            )
            cell.payload = .init(review: entity)
            cell.layoutIfNeeded()
            let estimateSize = cell.systemLayoutSizeFitting(
                .init(width: width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )
            return estimateSize
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        let width = collectionView.bounds.width
        guard let sections else {
            return .zero
        }
        let section = sections[section]
        switch section.section {
        case .image:
            return .init(width: width, height: 12)
        case .information:
            return .init(width: width, height: 12)
        default:
            return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .zero
    }

}

extension ProductDetailViewController: ProductDetailReviewWriteCellDelegate {
    func writeButtonDidTap() {
        listener?.attachStarRatingReview()
    }
    
    func sortButtonDidTap() {
        listener?.sortButtonDidTap()
    }
}

extension ProductDetailViewController: ProductDetailReviewCellDelegate {
    func goodButtonDidTap(review: ReviewEntity) {
        listener?.reviewLikeButtonDidTap(review: review)
    }
    
    func badButtonDidTap(review: ReviewEntity) {
        listener?.reviewHateButtonDidTap(review: review)
    }
}
