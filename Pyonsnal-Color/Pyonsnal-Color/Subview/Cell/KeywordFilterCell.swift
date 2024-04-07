//
//  KeywordFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/24.
//

import UIKit
import SnapKit

protocol KeywordFilterCellDelegate: AnyObject {
    func didTapDeleteButton(filter: FilterItemEntity)
}

final class KeywordFilterCell: UICollectionViewCell {
    
    enum Size {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let deleteButtonSize: CGFloat = 20
    }
    
    weak var delegate: KeywordFilterCellDelegate?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var filterItem: FilterItemEntity?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        configureUI()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    private func configureUI() {
        self.backgroundColor = .white
        self.makeRounded(with: Size.cornerRadius)
        self.makeBorder(width: Size.borderWidth, color: UIColor.red200.cgColor)
    }
    
    private func configureAction() {
        viewHolder.deleteButton.addTarget(
            self,
            action: #selector(didTapDeleteButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapDeleteButton() {
        guard let filterItem else { return }
        delegate?.didTapDeleteButton(filter: filterItem)
    }
    
    func configure(with filterItem: FilterItemEntity) {
        self.filterItem = filterItem
        self.filterItem?.isSelected = true
        if let eventTagName = EventTag(rawValue: filterItem.name)?.name {
            viewHolder.titleLabel.text = eventTagName
        } else {
            viewHolder.titleLabel.text = filterItem.name
        }
    }
    
    class ViewHolder: ViewHolderable {
        
        // MARK: - UI Component
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .red500
            label.font = .body3m
            return label
        }()
        
        let deleteButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconCloseSmall, for: .normal)
            button.setImageTintColor(with: .red500)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(titleLabel)
            view.addSubview(deleteButton)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing12)
                $0.top.equalToSuperview().offset(.spacing6)
                $0.centerY.equalToSuperview()
            }
            
            deleteButton.snp.makeConstraints {
                $0.leading.equalTo(titleLabel.snp.trailing).offset(.spacing2)
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.size.equalTo(Size.deleteButtonSize)
                $0.trailing.equalToSuperview().inset(.spacing8)
            }
            
        }
        
    }
}
