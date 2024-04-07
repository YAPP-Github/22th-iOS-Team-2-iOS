//
//  TermsButton.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/06.
//

import UIKit

final class TermsButton: UIButton {
    
    // MARK: - Initializer
    init(
        textColor: UIColor,
        font: UIFont,
        isSelected: Bool
    ) {
        super.init(frame: .zero)
        configureUI(textColor: textColor,
                    font: font)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    func setButtonState(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func isCurrentSelected() -> Bool {
        return isSelected
    }
    
    // MARK: - Private method
    private func configureUI(textColor: UIColor,
                             font: UIFont) {
        self.titleLabel?.font = font
        self.setTitleColor(textColor, for: .normal)
        self.setImage(.check, for: .normal)
        self.setImage(.checkSelected, for: .selected)
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                            left: .spacing8,
                                            bottom: 0,
                                            right: 0)
    }
}
