//
//  SelectionButton.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import UIKit

final class SelectionButton: UIButton {
    
    // MARK: - Declaration
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Method
//    override func layoutSubviews() {
//        if imageView != nil {
//            imageEdgeInsets = .init(top: 0, left: (bounds.width - 35), bottom: 0, right: 5)
//        }
//    }
    
    // MARK: - Private Method
    private func configureUI() {
        contentHorizontalAlignment = .left
        semanticContentAttribute = .forceRightToLeft
        titleLabel?.font = .body2m
        setTitleColor(.red500, for: .selected)
        setTitleColor(.gray700, for: .normal)
        setImage(ImageAssetKind.Icon.iconCheck.image?.withTintColor(.red500), for: .selected)
        setImage(.none, for: .normal)
    }
}
