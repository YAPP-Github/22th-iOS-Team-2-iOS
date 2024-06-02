//
//  ProductTastesView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 6/2/24.
//

import UIKit
import SnapKit

final class ProductTastesTagView: UIView {
    // MARK: - Initializer
    init(text: String) {
        super.init(frame: .zero)
        configureUI()
        configureView()
        configureConstraint()
        setText(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tastesTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red500
        label.font = .body3r
        return label
    }()
    
    private func setText(with text: String) {
        self.tastesTagLabel.text = text
    }
    
    private func configureUI() {
        self.backgroundColor = .red100
    }
    
    private func configureView() {
        self.addSubview(tastesTagLabel)
    }
    
    private func configureConstraint() {
        tastesTagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(.spacing2)
            $0.bottom.equalToSuperview().inset(.spacing2)
            $0.leading.equalToSuperview().inset(.spacing8)
            $0.trailing.equalToSuperview().inset(.spacing8)
        }
    }
}
