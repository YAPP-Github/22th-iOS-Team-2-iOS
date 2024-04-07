//
//  ProductDetailReviewWriteCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

final class ProductDetailReviewWriteCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let score: Double
        let reviewsCount: Int
        let sortItem: FilterItemEntity
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
    }
    
    weak var delegate: ProductDetailReviewWriteCellDelegate?
    
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
        viewHolder.reviewWriteButton.addTapGesture(
            target: self,
            action: #selector(reviewWriteButtonAction(_:))
        )
        
        viewHolder.sortButton.addTapGesture(
            target: self,
            action: #selector(reviewSortButtonAction(_:))
        )
    }
    
    private func updateUI() {
        guard let payload else {
            return
        }
        
        viewHolder.reviewCountLabel.text = "리뷰 \(payload.reviewsCount)개"
        viewHolder.ratingScoreLabel.text = "\(round(payload.score * 10) / 10)"
        viewHolder.starRatedView.payload = .init(score: payload.score)
        viewHolder.reviewWriteButton.setText(with: "상품 리뷰 작성 하기")
        viewHolder.sortButton.setText(with: payload.sortItem.name)
    }
    
    @objc private func reviewWriteButtonAction(_ sender: UITapGestureRecognizer) {
        delegate?.writeButtonDidTap()
    }
    
    @objc private func reviewSortButtonAction(_ sender: UITapGestureRecognizer) {
        delegate?.sortButtonDidTap()
    }
}
