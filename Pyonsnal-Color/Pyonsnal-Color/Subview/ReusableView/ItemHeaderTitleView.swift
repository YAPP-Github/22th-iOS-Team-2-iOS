//
//  ItemHeaderTitleView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/10.
//

import UIKit
import SnapKit

final class ItemHeaderTitleView: UICollectionReusableView {
    
    enum Size {
        static let labelGreaterThanEqualLeading: CGFloat = 100
    }
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String) {
        viewHolder.titleLabel.text = title
    }
}

extension ItemHeaderTitleView {
    class ViewHolder: ViewHolderable {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            return label
        }()
         
        func place(in view: UIView) {
            view.addSubview(titleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.top.equalToSuperview().offset(.spacing24)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
