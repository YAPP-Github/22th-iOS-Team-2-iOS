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
        case starRating // 별점
        case date // 날짜
        case tastes // 취향 태그
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
        label.numberOfLines = 2
        return label
    }()
    
    lazy var starRatedView = StarRatedView(score: 0)
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .body3r
        label.textColor = .gray400
        return label
    }()
    
    let tastesLabel: UILabel = {
        let label = UILabel()
        label.font = .body3r
        label.textColor = .red500
        label.numberOfLines = 2
        return label
    }()
    
    init(mode: Mode) {
        super.init(frame: .zero)
        self.initialize()
        self.configureView()
        self.addArrangedSubview(with: mode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTastes(tastesTag: [String]) {
        let tastes = tastesTag.map { "# \($0)"}.joined(separator: " ")
        self.tastesLabel.text = tastes
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
            right: .spacing16
        )
    }
    
    private func configureView() {
        self.addArrangedSubview(productImageView)
        self.addArrangedSubview(productInformationStackView)
        
        self.productInformationStackView.addArrangedSubview(storeImageView)
        self.productInformationStackView.addArrangedSubview(productNameLabel)
        self.productNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.tastesLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.productImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        self.storeImageView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
    
    private func addArrangedSubview(with mode: Mode) {
        switch mode {
        case .starRating:
            self.productInformationStackView.addArrangedSubview(starRatedView)
        case .date:
            self.productInformationStackView.addArrangedSubview(dateLabel)
        case .tastes:
            self.productInformationStackView.addArrangedSubview(tastesLabel)
        }
    }
}
