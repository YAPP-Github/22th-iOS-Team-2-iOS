//
//  ProductCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/14.
//

import UIKit
import Combine
import SnapKit

protocol ProductCellDelegate: AnyObject {
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction)
}

final class ProductCell: UICollectionViewCell {
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var product: (ProductDetailEntity)?
    
    weak var delegate: ProductCellDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        configureUI()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindActions() {
        viewHolder.favoriteButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self, let product = self.product else { return }
                
                if let isGuest = UserInfoService.shared.isGuest, !isGuest {
                    let isSelected = !self.viewHolder.favoriteButton.isSelected
                    self.setFavoriteButtonSelected(isSelected: isSelected)
                }

                let action: FavoriteButtonAction = self.getFavoriteButtonSelected() ? .add : .delete
                self.delegate?.didTapFavoriteButton(product: product, action: action)
            }.store(in: &cancellable)
    }
    
    func updateCell(with product: (ProductDetailEntity)?) {
        guard let product else { return }
        self.product = product
        viewHolder.titleLabel.text = product.name
        if let storeTypeImage = product.storeType.storeTagImage {
            viewHolder.convenienceStoreTagImageView.setImage(storeTypeImage)
        }
        viewHolder.itemImageView.setImage(with: product.imageURL)
        viewHolder.originalPriceLabel.text = product.price.addWon()
        viewHolder.newTagView.isHidden = !(product.isNew ?? false)
        if product.isNew ?? false {
            viewHolder.newTagView.snp.updateConstraints { make in
                make.width.equalTo(Size.newImageViewWidth)
            }
            
            viewHolder.titleLabel.snp.updateConstraints { make in
                make.leading.equalTo(viewHolder.newTagView.snp.trailing).offset(.spacing4)
            }
        } else {
            viewHolder.newTagView.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            viewHolder.titleLabel.snp.updateConstraints { make in
                make.leading.equalTo(viewHolder.newTagView.snp.trailing)
            }
        }
        hasExpiredLayerView(product: product)
        hasEventType(product.eventType)
        setFavoriteButtonSelected(isSelected: product.isFavorite ?? false)
    }
    
    // MARK: - Private Method
    private func configureUI() {
        let attributedText = viewHolder.discountPriceLabel.text?.strikeThrough(with: .gray500)
        viewHolder.discountPriceLabel.attributedText = attributedText
        viewHolder.convenienceStoreTagImageView.makeRounded(with: Size.convenientTagImageViewWidth / 2)
        makeRounded(with: Size.cornerRadius)
        makeBorder(width: Size.borderWidth, color: UIColor.gray200.cgColor)
    }
    
    private func hasEventType(_ event: EventTag?) {
        if let eventName = event?.name, !eventName.isEmpty {
            viewHolder.eventTagLabel.isHidden = false
            viewHolder.eventTagLabel.text = eventName
        } else {
            viewHolder.eventTagLabel.isHidden = true
        }
    }
    
    private func hasExpiredLayerView(product: ProductDetailEntity) {
        if let isExpired = product.isEventExpired {
            self.showEventCloseLayerView(isClosed: isExpired)
        }
    }
    
    func setFavoriteButtonSelected(isSelected: Bool) {
        viewHolder.favoriteButton.isSelected = isSelected
    }
    
    func getFavoriteButtonSelected() -> Bool {
        return viewHolder.favoriteButton.isSelected
    }
    
    func showEventCloseLayerView(isClosed: Bool) {
        viewHolder.eventCloseLayerView.isHidden = !isClosed
        if isClosed {
            self.updateFavoriteButtonConstraints()
        }
    }
    
    private func updateFavoriteButtonConstraints() {
        viewHolder.favoriteButton.removeFromSuperview()
        viewHolder.eventCloseLayerView.addSubview(viewHolder.favoriteButton)
        viewHolder.updateFavoriteButtonConstraints()
    }

}
