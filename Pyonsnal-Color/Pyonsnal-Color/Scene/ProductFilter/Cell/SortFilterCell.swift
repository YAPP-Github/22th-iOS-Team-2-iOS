//
//  SortFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import UIKit
import SnapKit

final class SortFilterCell: UICollectionViewCell {
    
    private let viewHolder = ViewHolder()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelectedState() : setUnselectedState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideCheckMark() {
        viewHolder.checkButton.isHidden = isSelected ? false : true
    }
    
    func configureCell(filterItem: FilterItemEntity) {
        viewHolder.titleLabel.text = filterItem.name
        isSelected = filterItem.isSelected
    }
    
    private func setSelectedState() {
        viewHolder.titleLabel.textColor = .red500
        viewHolder.checkButton.isHidden = false
    }
    
    private func setUnselectedState() {
        viewHolder.titleLabel.textColor = .black
        viewHolder.checkButton.isHidden = true
    }
}

extension SortFilterCell {
    final class ViewHolder: ViewHolderable {
        
        enum Image {
            static let checkMark = "checkmark"
        }
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            label.textColor = .black
            return label
        }()
        
        let checkButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconCheck, for: .normal)
            button.setImageTintColor(with: .red500)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(titleLabel)
            containerStackView.addArrangedSubview(checkButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.edges.equalTo(view)
            }
        }
    }
}
