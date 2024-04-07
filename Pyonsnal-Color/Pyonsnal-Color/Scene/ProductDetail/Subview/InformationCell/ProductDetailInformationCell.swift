//
//  ProductDetailInformationCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit
import SnapKit

final class ProductDetailInformationCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let productDetail: ProductDetailEntity
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { configure() }
    }
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
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
    
    private func configure() {
        guard let payload else {
            return
        }
        
        if let gift = payload.productDetail.gift {
            viewHolder.giftInformationView.isHidden = false
            viewHolder.productDescriptionLabel.snp.remakeConstraints { make in
                make.top.equalTo(viewHolder.productPriceLabel.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview()
            }
            
            viewHolder.giftInformationView.snp.remakeConstraints { make in
                make.top.equalTo(viewHolder.productDescriptionLabel.snp.bottom).offset(.spacing40)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            viewHolder.giftInformationView.payload = .init(giftEntity: gift)
        } else {
            viewHolder.giftInformationView.isHidden = true
            viewHolder.productDescriptionLabel.snp.remakeConstraints { make in
                make.top.equalTo(viewHolder.productPriceLabel.snp.bottom).offset(.spacing16)
                make.leading.bottom.trailing.equalToSuperview()
            }
            viewHolder.giftInformationView.snp.removeConstraints()
        }
        let productDetail = payload.productDetail
        viewHolder.updateDateLabel.text = productDetail.updatedTime
        if let isNew = productDetail.isNew {
            viewHolder.productTagListView.isHidden = false
            viewHolder.productTagListView.payload = .init(
                isNew: isNew, eventTags: productDetail.eventType
            )
        } else {
            viewHolder.productTagListView.isHidden = true
        }
        viewHolder.productNameLabel.text = productDetail.name
        viewHolder.productPriceLabel.text = productDetail.price
        viewHolder.productDescriptionLabel.text = productDetail.description
    }
}
