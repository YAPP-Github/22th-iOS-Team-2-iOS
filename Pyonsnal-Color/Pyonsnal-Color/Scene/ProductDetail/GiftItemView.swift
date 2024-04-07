//
//  GiftItemView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit

final class GiftItemView: UIView {
    // MARK: - Declaration
    
    struct Payload {
        var giftEntity: ProductGiftEntity
    }
    
    enum Constant {
        enum Size {
            static let contentViewRound: CGFloat = 16
            static let contentViewBorderWidth: CGFloat = 1
            static let giftImageViewSize: CGFloat = 100
            static let giftImageViewInset: CGFloat = 10
        }
        
        enum Color {
            static let contentViewBackgroundColor: UIColor = .init(rgbHexString: "#F7F7F9")
            static let contentViewBorderColor: UIColor = .init(rgbHexString: "#EAEAEC")
            static let giftImageBackgroundColor: UIColor = .white
            static let giftTitleTextColor: UIColor = .init(rgbHexString: "#343437")
            static let giftPriceTextColor: UIColor = .black
        }
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = Constant.Color.contentViewBackgroundColor
        view.makeRounded(with: Constant.Size.contentViewRound)
        view.makeBorder(
            width: Constant.Size.contentViewBorderWidth,
            color: Constant.Color.contentViewBorderColor.cgColor
        )
        return view
    }()
    
    private let giftImageBackgroundView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = Constant.Color.giftImageBackgroundColor
        return view
    }()
    
    private let giftImageView: UIImageView = {
        let imageView: UIImageView = .init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let giftInformationBackgroundView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let giftNameLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.textColor = Constant.Color.giftTitleTextColor
        label.font = .body4m
        return label
    }()
    
    private let giftPriceLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.textColor = Constant.Color.giftPriceTextColor
        label.font = .body3m
        return label
    }()
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func updateUI() {
        guard let gift = payload?.giftEntity else { return }
        
        giftImageView.setImage(with: gift.imageURL)
        giftNameLabel.text = gift.name
        giftPriceLabel.text = gift.price
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(giftImageBackgroundView)
        contentView.addSubview(giftInformationBackgroundView)
        
        giftImageBackgroundView.addSubview(giftImageView)
        
        giftInformationBackgroundView.addSubview(giftNameLabel)
        giftInformationBackgroundView.addSubview(giftPriceLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        giftImageBackgroundView.snp.makeConstraints { make in
            make.size.equalTo(Constant.Size.giftImageViewSize)
            make.top.leading.bottom.equalToSuperview()
        }
        
        giftInformationBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(giftImageBackgroundView.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        giftImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.Size.giftImageViewInset)
        }
        
        giftNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        giftPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(giftNameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
