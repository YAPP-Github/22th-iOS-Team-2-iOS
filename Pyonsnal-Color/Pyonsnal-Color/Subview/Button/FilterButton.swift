//
//  FilterButton.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

final class FilterButton: UIButton {
    
    enum Size {
        static let borderWidth: CGFloat = 1
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        configureUI()
        setUIUnSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    func setUISelected() {
        self.isSelected = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .gray700
        self.setImageTintColor(with: .white)
        self.makeBorder(width: 0, color: UIColor.clear.cgColor)
    }
    
    func setUIUnSelected() {
        self.isSelected = false
        self.setTitleColor(.gray500, for: .normal)
        self.backgroundColor = .white
        self.setImageTintColor(with: .gray500)
        self.makeBorder(width: Size.borderWidth, color: UIColor.gray200.cgColor)
    }
    
    // MARK: - Private method
    private func configureUI() {
        self.isEnabled = false
        self.titleLabel?.font = .body3m
        self.makeRounded(with: .spacing4)
        self.makeBorder(width: Size.borderWidth,
                        color: UIColor.gray200.cgColor)
        self.setImage(.filter, for: .normal)
        self.setTitleColor(.gray500, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.semanticContentAttribute = .forceRightToLeft
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: .spacing10, bottom: 0, right: .spacing4)
        
    }
}
