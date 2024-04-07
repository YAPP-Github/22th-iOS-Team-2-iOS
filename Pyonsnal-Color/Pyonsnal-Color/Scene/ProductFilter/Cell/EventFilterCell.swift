//
//  EventFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/28.
//

import UIKit
import SnapKit

final class EventFilterCell: UICollectionViewCell {
    
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
    
    func configureCell(filterItem: FilterItemEntity) {
        viewHolder.titleLabel.text = EventTag(rawValue: filterItem.name)?.name ?? ""
        isSelected = filterItem.isSelected
    }
    
    private func setSelectedState() {
        viewHolder.checkButton.setImage(.checkSelectedRed, for: .normal)
        viewHolder.titleLabel.textColor = .red500
    }
    
    private func setUnselectedState() {
        viewHolder.titleLabel.textColor = .black
        viewHolder.checkButton.setImage(.check, for: .normal)
    }
}

extension EventFilterCell {
    final class ViewHolder: ViewHolderable {
        
        enum Size {
            static let spacing: CGFloat = 10
            static let checkButtonRadius: CGFloat = 10
            static let checkButtonSize: CGFloat = 20
        }
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.spacing = Size.spacing
            return stackView
        }()
        
        let checkButton: UIButton = {
            let button = UIButton()
            button.makeRounded(with: Size.checkButtonRadius)
            button.setImage(.check, for: .normal)
            button.isUserInteractionEnabled = false
            return button
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            label.textColor = .black
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(checkButton)
            containerStackView.addArrangedSubview(titleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.leading.equalTo(view)
                $0.centerY.equalTo(view)
            }
            
            checkButton.snp.makeConstraints {
                $0.width.height.equalTo(Size.checkButtonSize)
            }
        }
    }
}
