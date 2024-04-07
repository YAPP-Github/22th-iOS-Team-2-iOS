//
//  ProductDetailImageCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

import SnapKit

extension ProductDetailImageCell {
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
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: .zero)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(imageView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(Size.imageViewSize)
                make.centerX.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(Size.imageViewTopBottomInset)
            }
        }
    }
}
