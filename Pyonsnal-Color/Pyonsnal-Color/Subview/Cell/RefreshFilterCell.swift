//
//  RefreshFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/24.
//

import UIKit
import SnapKit

protocol RefreshFilterCellDelegate: AnyObject {
    func didTapRefreshButton()
}

final class RefreshFilterCell: UICollectionViewCell {
    
    // MARK: - Interfaces
    enum Size {
        static let borderWidth: CGFloat = 1
    }
    
    weak var delegate: RefreshFilterCellDelegate?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
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
    
    private func configureUI() {
        self.makeRounded(with: .spacing16)
        self.makeBorder(width: Size.borderWidth, color: UIColor.gray200.cgColor)
    }
    
    private func configureAction() {
        viewHolder.refreshButton.addTarget(
            self,
            action: #selector(didTapRefreshButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapRefreshButton() {
        delegate?.didTapRefreshButton()
    }
    
    class ViewHolder: ViewHolderable {
        
        // MARK: - UI Component
        let refreshButton: UIButton = {
            let button = UIButton()
            button.setImage(.refreshFilter, for: .normal)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(refreshButton)
        }
        
        func configureConstraints(for view: UIView) {
            refreshButton.snp.makeConstraints {
                $0.top.leading.equalToSuperview().offset(.spacing6)
                $0.trailing.bottom.equalToSuperview().inset(.spacing6)
            }
        }
    }
        
}
