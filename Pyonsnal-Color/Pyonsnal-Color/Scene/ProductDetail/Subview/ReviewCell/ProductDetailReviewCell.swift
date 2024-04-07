//
//  ProductDetailReviewCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

protocol ProductDetailReviewCellDelegate: AnyObject {
    func goodButtonDidTap(review: ReviewEntity)
    func badButtonDidTap(review: ReviewEntity)
}

final class ProductDetailReviewCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let review: ReviewEntity
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
    }
    weak var delegate: ProductDetailReviewCellDelegate?
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureView() {
        viewHolder.place(in: contentView)
    }
    
    private func configureConstraint() {
        viewHolder.configureConstraints(for: contentView)
    }
    
    private func configureAction() {
        viewHolder.goodButton.addTarget(
            self,
            action: #selector(goodButtonAction(_:)),
            for: .touchUpInside
        )
        viewHolder.badButton.addTarget(
            self,
            action: #selector(badButtonAction(_:)),
            for: .touchUpInside
        )
    }
    
    private func updateUI() {
        guard let payload else {
            return
        }
        
        let review = payload.review
        viewHolder.reviewMetaView.payload = .init(review: review)
        if let imageURL = review.image {
            viewHolder.reviewImageView.isHidden = false
            viewHolder.reviewImageView.setImage(with: imageURL)
        } else {
            viewHolder.reviewImageView.isHidden = true
        }
        viewHolder.reviewTagListView.payload = .init(
            taste: review.taste,
            quality: review.quality,
            valueForMoney: review.valueForMoney
        )
        if review.contents.isEmpty {
            viewHolder.reviewLabel.isHidden = true
            viewHolder.reviewLabel.snp.removeConstraints()
            viewHolder.buttonBackgroundView.snp.remakeConstraints { make in
                make.top.equalTo(viewHolder.contentStackView.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.bottom.equalToSuperview().inset(.spacing20)
            }
        } else {
            viewHolder.reviewLabel.isHidden = false
            
            
            viewHolder.reviewLabel.snp.makeConstraints { make in
                make.top.equalTo(viewHolder.contentStackView.snp.bottom).offset(.spacing12)
                make.leading.trailing.equalToSuperview().inset(.spacing20)
            }
            viewHolder.buttonBackgroundView.snp.remakeConstraints { make in
                make.top.equalTo(viewHolder.reviewLabel.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.bottom.equalToSuperview().inset(.spacing20)
            }
        }
        viewHolder.reviewLabel.text = review.contents
        viewHolder.goodButton.payload = .init(
            feedbackKind: .good,
            isSelected: review.likeCount.writerIds.contains(UserInfoService.shared.memberID ?? 0),
            count: review.likeCount.likeCount
        )
        viewHolder.badButton.payload = .init(
            feedbackKind: .bad,
            isSelected: review.hateCount.writerIds.contains(UserInfoService.shared.memberID ?? 0),
            count: review.hateCount.hateCount
        )
    }
    
    @objc private func goodButtonAction(_ sender: UITapGestureRecognizer) {
        guard let payload else { return }
        delegate?.goodButtonDidTap(review: payload.review)
    }
    
    @objc private func badButtonAction(_ sender: UITapGestureRecognizer) {
        guard let payload else { return }
        delegate?.badButtonDidTap(review: payload.review)
    }
}
