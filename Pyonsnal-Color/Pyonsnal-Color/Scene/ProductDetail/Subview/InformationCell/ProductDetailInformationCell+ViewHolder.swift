//
//  ProductDetailInformationCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

import SnapKit

extension ProductDetailInformationCell {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Size {
            static let imageViewSize: CGFloat = 200
            static let imageViewTopBottomInset: CGFloat = 60
        }
        
        // MARK: - UI Component
        let contentView: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let updateDateLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .gray400
            label.font = .body3r
            return label
        }()
        
        private let textInfoStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = 16
            return stackView
        }()
        
        let productTagListView: ProductTagListView = {
            let productTagListView: ProductTagListView = .init()
            return productTagListView
        }()
        
        private let textContainerView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        let productNameLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .gray700
            label.font = .title1
            return label
        }()
        
        let productPriceLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .black
            label.font = .headLine
            return label
        }()
        
        let productDescriptionLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.numberOfLines = 0
            label.textColor = .gray600
            label.font = .body2r
            return label
        }()
        
        let giftInformationView: GiftInformationView = {
            let giftInformationView: GiftInformationView = .init()
            return giftInformationView
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(updateDateLabel)
            contentView.addSubview(textInfoStackView)
            
            textInfoStackView.addArrangedSubview(productTagListView)
            textInfoStackView.addArrangedSubview(textContainerView)
            
            textContainerView.addSubview(productNameLabel)
            textContainerView.addSubview(productPriceLabel)
            textContainerView.addSubview(productDescriptionLabel)
            textContainerView.addSubview(giftInformationView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            updateDateLabel.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(.spacing16)
            }
            
            textInfoStackView.snp.makeConstraints { make in
                make.top.equalTo(updateDateLabel.snp.bottom).offset(.spacing4)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.bottom.equalToSuperview().inset(.spacing40)
            }
            
            productNameLabel.snp.makeConstraints { make in
                make.height.equalTo(28)
                make.top.leading.trailing.equalToSuperview()
            }
            
            productPriceLabel.snp.makeConstraints { make in
                make.height.equalTo(38)
                make.top.equalTo(productNameLabel.snp.bottom).offset(.spacing4)
            }
            
            productDescriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(productPriceLabel.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview()
            }
            
            giftInformationView.snp.makeConstraints { make in
                make.top.equalTo(productDescriptionLabel.snp.bottom).offset(.spacing40)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
}
