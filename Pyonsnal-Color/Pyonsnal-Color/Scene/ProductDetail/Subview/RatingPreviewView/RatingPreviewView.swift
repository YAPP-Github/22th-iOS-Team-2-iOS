//
//  RatingPreviewView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/17.
//

import UIKit

final class RatingPreviewView: UIView {
    // MARK: - Declaration
    struct Payload {
        let ratingCount: Int
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.setImage(.iconReview)
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .body3m
        label.textColor = .gray700
        return label
    }()
    
    // MARK: - Interface
    var payload: Payload? {
        didSet {
            updateUI()
        }
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
        guard let payload else {
            return
        }
        
        countLabel.text = "\(payload.ratingCount)"
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(countLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.leading.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(iconImageView.snp.trailing).offset(.spacing2)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}
