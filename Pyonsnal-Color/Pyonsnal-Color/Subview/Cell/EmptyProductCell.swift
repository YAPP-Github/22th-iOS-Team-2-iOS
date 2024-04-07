//
//  EmptyProductCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/29.
//

import UIKit
import SnapKit

protocol EmptyProductCellDelegate: AnyObject {
    func didTapRefreshFilterButton()
}

final class EmptyProductCell: UICollectionViewCell {
    
    // MARK: - Interfaces
    enum Text {
        static let titleText = "앗! 원하는 상품 결과가 없어요."
        static let buttonTitleText = "필터 초기화 하기"
    }
    
    enum Size {
        static let buttonBorderWidth: CGFloat = 1
        static let filterRefreshButtonWidth: CGFloat = 140
        static let filterRefreshButtonHeight: CGFloat = 32
    }
    
    weak var delegate: EmptyProductCellDelegate?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAction() {
        viewHolder.filterRefreshButton.addTarget(
            self,
            action: #selector(didTapRefreshButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapRefreshButton() {
        delegate?.didTapRefreshFilterButton()
    }
    
    class ViewHolder: ViewHolderable {
        
        let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = .spacing16
            stackView.alignment = .center
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = EmptyProductCell.Text.titleText
            label.font = .body1r
            label.textColor = .gray600
            return label
        }()
        
        let filterRefreshButton: UIButton = {
            let button = UIButton()
            button.setText(with: EmptyProductCell.Text.buttonTitleText)
            button.titleLabel?.font = .body3m
            button.makeRounded(with: .spacing4)
            button.makeBorder(width: Size.buttonBorderWidth,
                            color: UIColor.gray200.cgColor)
            button.backgroundColor = .white
            button.setImage(.refreshFilter, for: .normal)
            button.setTitleColor(.gray500, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: Spacing.spacing8.value
            )
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            containerStackView.addArrangedSubview(titleLabel)
            containerStackView.addArrangedSubview(filterRefreshButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            filterRefreshButton.snp.makeConstraints {
                $0.width.equalTo(140)
                $0.height.equalTo(Size.filterRefreshButtonHeight)
            }
            
        }

    }
}
