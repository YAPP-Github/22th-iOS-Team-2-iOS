//
//  SingleLineReview.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/13.
//

import UIKit
import Combine
import SnapKit

protocol SingleLineReviewDelegate: AnyObject {
    func didSelectReview(_ review: Review)
}

final class SingleLineReview: UIView {

    private let viewHolder = ViewHolder()
    private let evaluationKind: ReviewEvaluationKind
    private var cancellable = Set<AnyCancellable>()
    weak var delegate: SingleLineReviewDelegate?
    
    init(evaluationKind: ReviewEvaluationKind) {
        self.evaluationKind = evaluationKind
        super.init(frame: .zero)
        
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
        configureReviewTitle()
        configureButtonAction()
        configureReviewButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonAction() {
        viewHolder.reviewButtonStackView.subviews
            .compactMap { $0 as? ReviewButton }
            .forEach { button in
                button
                    .tapPublisher
                    .sink { [weak self] in
                        self?.didSelectReviewButton(button)
                    }.store(in: &cancellable)
        }
    }
    
    private func configureReviewButtons() {
        viewHolder.goodReviewButton.payload = .init(kind: evaluationKind, state: .good)
        viewHolder.normalReviewButton.payload = .init(kind: evaluationKind, state: .normal)
        viewHolder.badReviewButton.payload = .init(kind: evaluationKind, state: .bad)
    }
    
    private func setSelectedButtonState(at index: Int) {
        guard let button = viewHolder.reviewButtonStackView.subviews[index] as? UIButton else {
            return
        }
        
        button.isSelected = true
        button.backgroundColor = .black
        button.removeBorder()
    }
    
    private func setDeselectedButtonState(at index: Int) {
        guard let button = viewHolder.reviewButtonStackView.subviews[index] as? UIButton else {
            return
        }
        
        button.isSelected = false
        button.backgroundColor = .white
        button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
    }

    private func didSelectReviewButton(_ sender: ReviewButton) {
        let index = sender.index
        guard let payload = sender.payload else { return }
        
        viewHolder.reviewButtonStackView.subviews
            .compactMap { $0 as? ReviewButton }
            .forEach {
                $0.index == index ? setSelectedButtonState(at: index) : setDeselectedButtonState(at: $0.index)
            }
        delegate?.didSelectReview(Review(kind: payload.kind, state: payload.state))
    }
    
    private func configureReviewTitle() {
        viewHolder.titleLabel.text = evaluationKind.detailReviewTitle
    }
    
    func hasSelected() -> Bool {
        let result = viewHolder.reviewButtonStackView.subviews
            .compactMap { $0 as? UIButton }
            .filter { $0.isSelected }
            .count
        
        return result == 1 ? true : false
    }
    
    func selectReviewButton(_ state: ReviewEvaluationState) {
        let result = viewHolder.reviewButtonStackView.subviews
            .compactMap { $0 as? ReviewButton }
            .filter { $0.payload?.state == state }
        
        result.forEach { didSelectReviewButton($0) }
    }
}

extension SingleLineReview {
    final class ViewHolder: ViewHolderable {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            return label
        }()
        
        let reviewButtonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            stackView.spacing = .spacing8
            return stackView
        }()
        
        let goodReviewButton = ReviewButton(index: 0)
        let normalReviewButton = ReviewButton(index: 1)
        let badReviewButton = ReviewButton(index: 2)
        
        func place(in view: UIView) {
            view.addSubview(titleLabel)
            view.addSubview(reviewButtonStackView)
            
            reviewButtonStackView.addArrangedSubview(goodReviewButton)
            reviewButtonStackView.addArrangedSubview(normalReviewButton)
            reviewButtonStackView.addArrangedSubview(badReviewButton)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.leading.top.equalTo(view)
            }
            
            reviewButtonStackView.snp.makeConstraints {
                $0.leading.bottom.trailing.equalTo(view)
                $0.top.equalTo(titleLabel.snp.bottom).offset(.spacing20)
                $0.height.equalTo(36)
            }
        }
    }
}
