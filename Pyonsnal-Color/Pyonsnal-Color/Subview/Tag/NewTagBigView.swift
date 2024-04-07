//
//  NewTagView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/07.
//

import UIKit
import SnapKit

final class NewTagView: UIView {
    // MARK: - Declaration
    enum Size {
        static let titleLabelWidth: CGFloat = 46
        static let titleLabelHeight: CGFloat = 28
    }
    
    enum ViewMode {
        case small, big
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.font = .body3m
        label.textColor = .red500
        label.text = "NEW"
        return label
    }()
    
    // MARK: - Initializer
    init(mode: ViewMode) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint(with: mode)
        updateTextFont(with: mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureConstraint(with mode: ViewMode) {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if mode == .big {
            titleLabel.snp.makeConstraints { make in
                make.width.equalTo(Size.titleLabelWidth)
                make.height.equalTo(Size.titleLabelHeight)
                make.edges.equalToSuperview()
            }
        } else if mode == .small {
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
    }
    
    private func updateTextFont(with mode: ViewMode) {
        titleLabel.font = mode == .small ? .label1 : .title1
    }

}
