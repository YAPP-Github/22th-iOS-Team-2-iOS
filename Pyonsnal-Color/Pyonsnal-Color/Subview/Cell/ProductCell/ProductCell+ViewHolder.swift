//
//  ProductCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/19.
//

import UIKit

extension ProductCell {
    enum Size {
        static let productImageViewMargin: CGFloat = 25.5
        static let dividerHeight: CGFloat = 1
        static let productImageContainerViewHeight: CGFloat = 160
        static let convenientTagImageViewWidth: CGFloat = 36
        static let eventTagImageViewWidth: CGFloat = 38
        static let eventTagImageViewHeight: CGFloat = 20
        static let newImageViewWidth: CGFloat = 32
        static let priceContainerViewHeight: CGFloat = 64
        static let eventTagImageviewRadius: CGFloat = 10
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let favoriteButtonSize: CGFloat = 44
    }
    
    final class ViewHolder: ViewHolderable {
        
        // MARK: - UI Component
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.backgroundColor = .white
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 0
            return stackView
        }()
        
        let productImageContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let itemImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let dividerView: UIView = {
            let dividerView = UIView()
            dividerView.backgroundColor = .gray100
            return dividerView
        }()
        
        let itemInfoContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let itemInfoTopStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = .spacing4
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        let newTagView = NewTagView(mode: .small)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body4m
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        
        let priceContainerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let originalPriceLabel: UILabel = {
            let label = UILabel()
            label.font = .body3m
            return label
        }()
        
        let discountPriceLabel: UILabel = {
            let label = UILabel()
            label.font = .body4r
            return label
        }()
        
        let convenienceStoreTagImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .blue
            return imageView
        }()
        
        let eventTagLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .green500
            label.font = .body4m
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        let favoriteButton: UIButton = {
            let button = UIButton()
            button.setImage(.favorite, for: .normal)
            button.setImage(.favoriteSelected, for: .selected)
            return button
        }()
        
        let eventCloseLayerView: UIView = {
            let view = UIView()
            view.backgroundColor = .black.withAlphaComponent(0.2)
            view.isHidden = true
            view.layer.masksToBounds = true
            return view
        }()
        
        let eventCloseLabel: UILabel = {
            let label = UILabel()
            label.text = "행사 종료"
            label.textColor = .white
            label.font = .title2
            return label
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(stackView)
            
            stackView.addArrangedSubview(productImageContainerView)
            stackView.addArrangedSubview(dividerView)
            stackView.addArrangedSubview(itemInfoContainerView)
            
            productImageContainerView.addSubview(itemImageView)
            productImageContainerView.addSubview(convenienceStoreTagImageView)
            productImageContainerView.addSubview(eventTagLabel)
            productImageContainerView.addSubview(favoriteButton)
            
            itemInfoContainerView.addSubview(itemInfoTopStackView)
            itemInfoContainerView.addSubview(priceContainerView)
            
            itemInfoTopStackView.addArrangedSubview(newTagView)
            itemInfoTopStackView.addArrangedSubview(titleLabel)
            
            priceContainerView.addSubview(originalPriceLabel)
            priceContainerView.addSubview(discountPriceLabel)
            
            // close Layer
            view.addSubview(eventCloseLayerView)
            eventCloseLayerView.addSubview(eventCloseLabel)
        }
        
        func configureConstraints(for view: UIView) {
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            productImageContainerView.snp.makeConstraints {
                $0.width.equalTo(stackView.snp.width)
                $0.height.equalTo(Size.productImageContainerViewHeight)
            }
            
            dividerView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.height.equalTo(Size.dividerHeight)
            }
            
            itemImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().offset(Size.productImageViewMargin)
                $0.trailing.bottom.equalToSuperview().inset(Size.productImageViewMargin)
            }
            
            convenienceStoreTagImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(.spacing12)
                $0.width.height.equalTo(Size.convenientTagImageViewWidth)
            }
            
            eventTagLabel.snp.makeConstraints {
                $0.trailing.bottom.equalToSuperview()
                $0.width.equalTo(Size.eventTagImageViewWidth)
                $0.height.equalTo(Size.eventTagImageViewHeight)
            }
            
            self.updateFavoriteButtonConstraints()
            
            itemInfoContainerView.snp.makeConstraints {
                $0.leading.equalTo(stackView)
            }
            
            itemInfoTopStackView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().offset(.spacing12)
                $0.trailing.lessThanOrEqualToSuperview().inset(.spacing12)
            }
            
            newTagView.snp.makeConstraints {
                $0.width.equalTo(Size.newImageViewWidth)
                $0.centerY.equalTo(titleLabel)
            }
            
            titleLabel.snp.makeConstraints {
                $0.height.equalTo(titleLabel.font.customLineHeight)
                $0.leading.equalTo(newTagView.snp.trailing).offset(.spacing4)
            }
            
            priceContainerView.snp.makeConstraints {
                $0.top.equalTo(itemInfoTopStackView.snp.bottom).offset(.spacing4)
                $0.leading.trailing.bottom.equalToSuperview().inset(.spacing12)
            }
            
            originalPriceLabel.snp.contentHuggingHorizontalPriority = 251
            discountPriceLabel.snp.contentHuggingHorizontalPriority = 250
            
            originalPriceLabel.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
            }
            
            discountPriceLabel.snp.makeConstraints {
                $0.leading.equalTo(originalPriceLabel.snp.trailing).offset(.spacing4)
                $0.top.trailing.bottom.equalToSuperview()
            }
            
            eventCloseLayerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            eventCloseLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        func updateFavoriteButtonConstraints() {
            favoriteButton.snp.makeConstraints {
                $0.size.equalTo(Size.favoriteButtonSize)
                $0.top.trailing.equalToSuperview()
            }
        }
    }

}
