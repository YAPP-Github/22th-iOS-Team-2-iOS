//
//  ProductDetailImageCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

final class ProductDetailImageCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let imageURL: URL
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
        viewHolder.imageView.setImage(with: payload.imageURL)
    }
}
