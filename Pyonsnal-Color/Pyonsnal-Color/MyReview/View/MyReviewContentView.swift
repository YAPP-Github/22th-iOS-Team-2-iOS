//
//  MyReviewContentView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import UIKit
import SnapKit

class MyReviewContentView: UIView, UIContentView {
    static let identifier = "MyReviewContentView"
    
    var configuration: any UIContentConfiguration
    private let storeImageViewHeight: CGFloat = 20
    
    private var productInfoStackView = ProductInfoStackView(mode: .date)
    
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        configureView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(productInfoStackView)
        productInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        guard let configuration = configuration as? MyReviewContentConfiguration else { return }
        if let imageUrl = URL(string: configuration.imageUrl) {
            self.productInfoStackView.productImageView.setImage(with: imageUrl)
        }
        
        self.productInfoStackView.productNameLabel.text = configuration.title
        
        self.productInfoStackView.storeImageView.setImage(configuration.storeImageIcon.storeIcon)
        self.productInfoStackView.storeImageView.snp.makeConstraints { make in
            guard let storeIcon = configuration.storeImageIcon.storeIcon.image else { return }
            let ratio = storeIcon.size.width / storeIcon.size.height
            let newWidth = self.storeImageViewHeight * ratio
            make.width.equalTo(newWidth)
        }
        
        if let date = configuration.date {
            let dateString = DateFormatter.productLastUpdateFormatter.date(from: date)?.toString()
            self.productInfoStackView.dateLabel.text = dateString
        }
    }
}
