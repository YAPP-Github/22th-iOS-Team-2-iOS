//
//  ProductDetailInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs
import Combine

protocol ProductDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachStarRatingReview(with productDetail: ProductDetailEntity)
    func detachStarRatingReview()
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
    func attachLoginPopup()
    func detachLoginPopup()
    func attachLoggedOut()
    func detachLoggedOut(animated: Bool)
}

protocol ProductDetailPresentable: Presentable {
    var listener: ProductDetailPresentableListener? { get set }
    func setFavoriteState(isSelected: Bool?)
    func reloadCollectionView(with sectionModels: [ProductDetailSectionModel])
    func updateHeaderImage(storeIcon: ImageAssetKind.StoreIcon)
}

protocol ProductDetailListener: AnyObject {
    func popProductDetail()
    func routeToLoggedIn()
}

final class ProductDetailInteractor: PresentableInteractor<ProductDetailPresentable>,
                                     ProductDetailInteractable,
                                     ProductDetailPresentableListener {
    
    weak var router: ProductDetailRouting?
    weak var listener: ProductDetailListener?

    // MARK: - Private Property
    private let favoriteAPIService: FavoriteAPIService
    private let dependency: ProductDetailDependency
    private(set) var product: ProductDetailEntity
    private var sortItem: FilterItemEntity = .init(name: "최신순", code: 0, image: nil, isSelected: true)
    private var cancellable = Set<AnyCancellable>()
    
    // in constructor.
    init(
        presenter: ProductDetailPresentable,
        favoriteAPIService: FavoriteAPIService,
        dependency: ProductDetailDependency,
        product: ProductDetailEntity
    ) {
        self.dependency = dependency
        self.favoriteAPIService = favoriteAPIService
        self.product = product
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        requestProductDetail()
        presenter.updateHeaderImage(storeIcon: product.storeType.storeIcon)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func popViewController() {
        listener?.popProductDetail()
    }
    
    func addFavorite() {
        if let isGuest = UserInfoService.shared.isGuest, isGuest {
            router?.attachLoginPopup()
        } else {
            favoriteAPIService.addFavorite(
                productId: product.id,
                productType: product.productType
            ).sink { [weak self] response in
                self?.presenter.setFavoriteState(isSelected: true)
            }.store(in: &cancellable)
        }
    }
        
    func deleteFavorite() {
        if let isGuest = UserInfoService.shared.isGuest, isGuest {
            router?.attachLoginPopup()
        } else {
            favoriteAPIService.deleteFavorite(
                productId: product.id,
                productType: product.productType
            ).sink { [weak self] response in
                self?.presenter.setFavoriteState(isSelected: false)
            }.store(in: &cancellable)
        }
    }
    
    func refresh() {
        requestProductDetail()
    }
        
    func reloadData(with productDetail: ProductDetailEntity) {
        self.product = productDetail
        
        var sectionModels: [ProductDetailSectionModel] = []
        sectionModels.append(
            .init(
                section: ProductDetailSection.image,
                items: [
                    ProductDetailSectionItem.image(imageURL: productDetail.imageURL)
                ]
            )
        )
        sectionModels.append(
            .init(
                section: ProductDetailSection.information,
                items: [
                    ProductDetailSectionItem.information(product: productDetail)
                ]
            )
        )
        if let avgScore = productDetail.avgScore {
            sectionModels.append(
                .init(
                    section: ProductDetailSection.reviewWrite,
                    items: [
                        ProductDetailSectionItem.reviewWrite(
                            score: avgScore,
                            reviewsCount: productDetail.reviews.count,
                            sortItem: sortItem
                        )
                    ]
                )
            )
        }
        sectionModels.append(
            .init(
                section: ProductDetailSection.review,
                items: productDetail.reviews.map { ProductDetailSectionItem.review(productReview: $0) }
            )
        )
        presenter.reloadCollectionView(with: sectionModels)
        presenter.setFavoriteState(isSelected: productDetail.isFavorite)
    }
    
    func writeButtonDidTap() {
        
    }
    
    func sortButtonDidTap() {
        var filterItems: [FilterItemEntity] = [
            .init(name: "최신순", code: 0, image: nil),
            .init(name: "좋아요순", code: 1, image: nil)
        ]
        if let index = filterItems.firstIndex { $0.code == sortItem.code } {
            filterItems[index] = sortItem
        }
        router?.attachProductFilter(
            of: .init(
                filterType: .sort,
                defaultText: "최신순",
                filterItem: filterItems
            )
        )
    }
    
    func reviewLikeButtonDidTap(review: ReviewEntity) {
        if let isGuest = UserInfoService.shared.isGuest, isGuest {
            router?.attachLoginPopup()
        } else {
            guard let memberID =  UserInfoService.shared.memberID,
                  !review.likeCount.writerIds.contains(memberID) else {
                return
            }
            requestReviewLike(reviewID: review.reviewId, writerID: "\(memberID)")
        }
    }
    
    func reviewHateButtonDidTap(review: ReviewEntity) {
        if let isGuest = UserInfoService.shared.isGuest, isGuest {
            router?.attachLoginPopup()
        } else {
            guard let memberID =  UserInfoService.shared.memberID,
                  !review.hateCount.writerIds.contains(memberID) else {
                return
            }
            requestReviewHate(reviewID: review.reviewId, writerID: "\(memberID)")
        }
    }
    
    func applyFilterItems(_ items: [FilterItemEntity], type: FilterType) {
    }
    
    func applySortFilter(item: FilterItemEntity) {
        sortItem = item
        sortItem.isSelected = true
        var filterName: String?
        switch item.code {
        case 0:
            filterName = "recent"
        case 1:
            filterName = "like"
        default:
            filterName = nil
        }
        logging(.sortFilterClick, parameter: [
            .reviewSortFilterName: filterName ?? "nil"
        ])
        if let updatedProduct = updateReviewSort(product: product, item: item) {
            reloadData(with: updatedProduct)
        }
        router?.detachProductFilter()
    }
    
    func productFilterDidTapCloseButton() {
        router?.detachProductFilter()
    }
    
    private func updateReviewSort(
        product: ProductDetailEntity,
        item: FilterItemEntity
    ) -> ProductDetailEntity?{
        switch item.code {
        case 0:
            var updatedReviews = product.reviews
            updatedReviews.sort(by: { $0.createdTime.date ?? .init() > $1.createdTime.date ?? .init() })
            let updatedProduct = product.updateReviews(reviews: updatedReviews)
            return updatedProduct
        case 1:
            var updatedReviews = product.reviews
            updatedReviews.sort(by: { $0.likeCount.likeCount > $1.likeCount.likeCount })
            let updatedProduct = product.updateReviews(reviews: updatedReviews)
            return updatedProduct
        default:
            return nil
        }
    }
    
    private func requestProductDetail() {
        switch product.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductDetail(id: product.id)
                .sink { [weak self] response in
                    if let self,
                       let product = response.value,
                       let updatedProduct = self.updateReviewSort(product: product, item: self.sortItem) {
                        self.reloadData(with: updatedProduct)
                    }
                }
                .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductDetail(id: product.id)
                .sink { [weak self] response in
                    if let self,
                       let product = response.value,
                       let updatedProduct = self.updateReviewSort(product: product, item: self.sortItem) {
                        self.reloadData(with: updatedProduct)
                    }
                }
                .store(in: &cancellable)
        }
    }
    
    private func requestReviewLike(reviewID: String, writerID: String) {
        switch product.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductReviewLike(
                productID: product.id,
                reviewID: reviewID,
                writerID: writerID
            )
            .sink { [weak self] _ in
                self?.updateReviewLike(reviewID: reviewID)
            }
            .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductReviewLike(
                productID: product.id,
                reviewID: reviewID,
                writerID: writerID
            )
            .sink { [weak self] _ in
                self?.updateReviewLike(reviewID: reviewID)
            }
            .store(in: &cancellable)
        }
    }
    
    private func requestReviewHate(reviewID: String, writerID: String) {
        switch product.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductReviewHate(
                productID: product.id,
                reviewID: reviewID,
                writerID: writerID
            )
            .sink { [weak self] _ in
                self?.updateReviewHate(reviewID: reviewID)
            }
            .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductReviewHate(
                productID: product.id,
                reviewID: reviewID,
                writerID: writerID
            )
            .sink { [weak self] _ in
                self?.updateReviewHate(reviewID: reviewID)
            }
            .store(in: &cancellable)
        }
    }
    
    func attachStarRatingReview() {
        if let isGuest = UserInfoService.shared.isGuest, isGuest {
            router?.attachLoginPopup()
        } else {
            logging(.writeReviewClick, parameter: [
                .productName: product.name
            ])
            router?.attachStarRatingReview(with: product)
        }
    }
    
    func detachStarRatingReview() {
        router?.detachStarRatingReview()
    }
    
    private func updateReviewLike(reviewID: String) {
        guard let memberID = UserInfoService.shared.memberID else {
            return
        }
        
        guard let reviewIndex = product.reviews.firstIndex(
            where: { $0.reviewId == reviewID }
        ) else {
            return
        }
        let review = product.reviews[reviewIndex]
        var likeWriterIds = review.likeCount.writerIds
        likeWriterIds.append(memberID)
        
        let hateWriterIds = review.hateCount.writerIds.filter { $0 != memberID }
        let hateCount = hateWriterIds.count
        let updatedReview = review.update(
            likeCount: .init(writerIds: likeWriterIds, likeCount: review.likeCount.likeCount + 1),
            hateCount: .init(writerIds: hateWriterIds, hateCount: hateCount)
        )
        
        var updatedReviews = product.reviews
        updatedReviews[reviewIndex] = updatedReview
        let updatedProductDetail = product.updateReviews(reviews: updatedReviews)
        reloadData(with: updatedProductDetail)
    }
    
    private func updateReviewHate(reviewID: String) {
        guard let memberID = UserInfoService.shared.memberID else {
            return
        }
        
        guard let reviewIndex = product.reviews.firstIndex(
            where: { $0.reviewId == reviewID }
        ) else {
            return
        }
        let review = product.reviews[reviewIndex]
        var hateWriterIds = review.hateCount.writerIds
        hateWriterIds.append(memberID)
        
        let likeWriterIds = review.likeCount.writerIds.filter { $0 != memberID }
        let likeCount = likeWriterIds.count
        
        let updatedReview = review.update(
            likeCount: .init(writerIds: likeWriterIds, likeCount: likeCount),
            hateCount: .init(writerIds: hateWriterIds, hateCount: review.hateCount.hateCount + 1)
        )
        
        var updatedReviews = product.reviews
        updatedReviews[reviewIndex] = updatedReview
        let updatedProductDetail = product.updateReviews(reviews: updatedReviews)
        reloadData(with: updatedProductDetail)
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
