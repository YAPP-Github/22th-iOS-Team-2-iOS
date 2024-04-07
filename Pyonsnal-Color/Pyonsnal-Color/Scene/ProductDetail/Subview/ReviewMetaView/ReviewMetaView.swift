//
//  ReviewMetaView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/17.
//

import UIKit

final class ReviewMetaView: UIView {
    // MARK: - Declaration
    struct Payload {
        let review: ReviewEntity
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.makeRounded(with: 16)
        imageView.makeBorder(width: 0.5, color: UIColor.gray300.cgColor)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .body3m
        label.textColor = .black
        return label
    }()
    
    let ratingPreviewView: RatingPreviewView = {
        let view = RatingPreviewView()
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray400
        label.font = .body3r
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
        
        let review = payload.review
        profileImageView.setImage(.tagStore)
        nameLabel.text = review.writerName
        ratingPreviewView.payload = .init(ratingCount: Int(review.score))
        dateLabel.text = review.updatedTime
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingPreviewView)
        contentView.addSubview(dateLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(.spacing8)
        }
        
        ratingPreviewView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(.spacing2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(.spacing8)
            make.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview()
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(.spacing8)
            make.trailing.equalToSuperview()
        }
    }
}
