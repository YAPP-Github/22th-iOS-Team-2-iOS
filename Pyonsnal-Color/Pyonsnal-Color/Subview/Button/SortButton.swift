//
//  SortButton.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

final class SortButton: UIButton {
    
    enum Size {
        static let borderWidth: CGFloat = 1
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    private func configureUI() {
        self.isEnabled = false
        self.titleLabel?.font = .body3m
        self.backgroundColor = .white
        self.makeRounded(with: .spacing4)
        self.makeBorder(
            width: Size.borderWidth,
            color: UIColor.gray200.cgColor
        )
        self.setImage(.sortFilter, for: .normal)
        self.setTitleColor(.gray500, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: .spacing6,
            bottom: 0,
            right: .spacing10
        )
    }

}
