//
//  ProductInfoStackView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import UIKit
import SnapKit

class ProductInfoStackView: UIStackView {
    enum Mode {
        case starRating
        case date
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
        imageView.makeRounded(with: .spacing16)
        return imageView
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .spacing8
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body3m
        label.numberOfLines = 1
        return label
    }()
    
    let starRatedView = StarRatedView(score: 0)
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .body3r
        label.textColor = .gray400
        return label
    }()
    
    init(mode: Mode) {
        super.init(frame: .zero)
        self.initialize()
        self.configureView(with: mode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = .spacing16
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(
            top: .spacing24,
            left: .spacing16,
            bottom: .spacing24,
            right: 0
        )
    }
    
    private func configureView(with mode: Mode) {
        self.addArrangedSubview(productImageView)
        self.addArrangedSubview(productInformationStackView)
        
        self.productInformationStackView.addArrangedSubview(storeImageView)
        self.productInformationStackView.addArrangedSubview(productNameLabel)
        
        switch mode {
        case .starRating:
            self.productInformationStackView.addArrangedSubview(starRatedView)
        case .date:
            self.productInformationStackView.addArrangedSubview(dateLabel)
        }
        
        self.productImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        self.storeImageView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
}
