//
//  DetailReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import UIKit
import Combine
import ModernRIBs

protocol DetailReviewRouting: ViewableRouting {
    func attachPopup(isApply: Bool)
    func detachPopup()
}

protocol DetailReviewPresentable: Presentable {
    var listener: DetailReviewPresentableListener? { get set }
    var reviews: [ReviewEvaluationKind: ReviewEvaluationState] { get }
    var score: Int { get }
    func getReviewContents() -> String
    func getReviewImage() -> UIImage?
}

protocol DetailReviewListener: AnyObject {
    func detachDetailReview()
    func routeToProductDetail()
    func saveReviewInput(_ input: UserReviewInput)
}

final class DetailReviewInteractor: PresentableInteractor<DetailReviewPresentable>,
                                    DetailReviewInteractable,
                                    DetailReviewPresentableListener {
    
    weak var router: DetailReviewRouting?
    weak var listener: DetailReviewListener?
    
    private var cancellable = Set<AnyCancellable>()
    private var memberInfo: MemberInfoEntity?
    private var isReviewUploading: Bool = false
    private let component: DetailReviewComponent
    private let productDetail: ProductDetailEntity
    
    init(
        presenter: DetailReviewPresentable,
        component: DetailReviewComponent,
        productDetail: ProductDetailEntity
    ) {
        self.component = component
        self.productDetail = productDetail
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        requestMemberInfo()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapBackButton() {
        let review = UserReviewInput(
            reviews: presenter.reviews,
            reviewContents: presenter.getReviewContents(),
            reviewImage: presenter.getReviewImage()
        )
        
        listener?.saveReviewInput(review)
        listener?.detachDetailReview()
    }
    
    func didTapApplyButton() {
        router?.attachPopup(isApply: true)
    }
    
    func popupDidTapDismissButton() {
        router?.detachPopup()
    }
    
    func popupDidTapBackButton() {
        router?.detachPopup()
        listener?.detachDetailReview()
    }
    
    func routeToProductDetail() {
        router?.detachPopup()
        
        if !isReviewUploading {
            uploadReview { [weak self] in
                self?.isReviewUploading = false
                self?.listener?.routeToProductDetail()
            }
        }
    }
    
    private func requestMemberInfo() {
        component.memberAPIService.info()
            .sink { [weak self] response in
                if let memberInfo = response.value {
                    self?.memberInfo = memberInfo
                }
            }.store(in: &cancellable)
    }
    
    private func uploadReview(_ closure: @escaping () -> Void) {
        guard let memberInfo,
              let reviewUploadEntity = configureReviewUploadEntity(memberInfo: memberInfo)
        else {
            return
        }
    
        let image = presenter.getReviewImage()
        
        isReviewUploading = true
        switch productDetail.productType {
        case .pb:
            component.productAPIService.uploadPBReview(
                reviewUploadEntity,
                image: image,
                productId: productDetail.id
            ) { closure() }
        case .event:
            component.productAPIService.uploadEventReview(
                reviewUploadEntity,
                image: image,
                productId: productDetail.id
            ) { closure() }
        }
    }
    
    private func configureReviewUploadEntity(memberInfo: MemberInfoEntity) -> ReviewUploadEntity? {
        guard let taste = presenter.reviews[.taste],
              let quality = presenter.reviews[.quality],
              let price = presenter.reviews[.valueForMoney]
        else {
            return nil
        }
        
        let reviewEntity = ReviewUploadEntity(
            taste: taste.rawValue,
            quality: quality.rawValue,
            valueForMoney: price.rawValue,
            score: Double(presenter.score),
            contents: presenter.getReviewContents(),
            writerId: memberInfo.memberId,
            writerName: memberInfo.nickname
        )
        
        return reviewEntity
    }
}
