//
//  EmptyCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/24.
//

import UIKit

extension EmptyCell {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Size {
            static let titleLabelHeight: CGFloat = 26
            static let subtitleLabelHeight: CGFloat = 26
        }
        
        // MARK: - UI Component
        let contentView: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let labelStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = .spacing8
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.textAlignment = .center
            label.font = .body1r
            label.textColor = .gray600
            return label
        }()
        
        let subtitleLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.textAlignment = .center
            label.font = .body3r
            label.textColor = .gray500
            return label
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(labelStackView)
            
            labelStackView.addArrangedSubview(titleLabel)
            labelStackView.addArrangedSubview(subtitleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            labelStackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(Size.titleLabelHeight)
            }
            
            subtitleLabel.snp.makeConstraints { make in
                make.height.equalTo(Size.subtitleLabelHeight)
            }
        }
    }
}
