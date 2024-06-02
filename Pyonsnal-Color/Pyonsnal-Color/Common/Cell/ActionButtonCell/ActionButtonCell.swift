//
//  ActionButtonCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 6/2/24.
//

import UIKit
import Combine

protocol ActionButtonCellDelegate: AnyObject {
    func actionButtonDidTap()
}

final class ActionButtonCell: UICollectionViewCell {
    // MARK: - Interfaces
    enum Constants {
        enum Size {
            static let actionButtonHeight: CGFloat = 40
            static let actionButtonRadius: CGFloat = 16
        }
        
        enum Text {
            static let writeReview = "상품 리뷰 작성 하기"
            static let showProduct = "상품 보러 가기"
        }
    }
    
    weak var delegate: ActionButtonCellDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setConstraints()
        self.bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let actionButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.makeRounded(with: Constants.Size.actionButtonRadius)
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .body2m
        return button
    }()
    
    // MARK: - Private Methods
    private func setConstraints() {
        self.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Size.actionButtonHeight)
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(.spacing16)
        }
    }
    
    private func bindActions() {
        actionButton.tapPublisher.sink { [weak self] in
            self?.delegate?.actionButtonDidTap()
        }.store(in: &cancellables)
    }
}
