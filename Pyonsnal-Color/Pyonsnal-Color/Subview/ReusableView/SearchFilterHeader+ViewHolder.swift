//
//  SearchFilterHeader+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/29.
//

import UIKit

extension SearchFilterHeader {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Text {
            static let sortButtonText = "최신순"
        }
        
        // MARK: - UI Component
        let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        let titleLabel: UILabel = {
            let label: UILabel = .init()
            label.font = .title2
            label.textColor = .gray700
            return label
        }()
        
        let sortButton: SortButton = {
            let sortButton: SortButton = .init()
            sortButton.isEnabled = true
            sortButton.setTitle(Text.sortButtonText, for: .normal)
            return sortButton
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(sortButton)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(26)
                make.top.equalToSuperview().offset(.spacing24)
                make.leading.equalToSuperview().offset(.spacing16)
                make.bottom.equalToSuperview()
            }
            
            sortButton.snp.makeConstraints { make in
                make.height.equalTo(32)
                make.leading.equalTo(titleLabel.snp.trailing).offset(.spacing16)
                make.trailing.equalToSuperview().inset(.spacing16)
                make.bottom.equalToSuperview()
            }
        }
    }
}
