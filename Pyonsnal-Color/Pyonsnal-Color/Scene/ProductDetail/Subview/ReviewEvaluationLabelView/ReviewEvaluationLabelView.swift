//
//  ReviewEvaluationLabelView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/10/28.
//

import UIKit

import SnapKit

final class ReviewEvaluationLabelView: UIView {
    
    // MARK: - Declaration
    
    struct Payload {
        let kind: ReviewEvaluationKind
        let state: ReviewEvaluationState
    }
    
    // MARK: - UI Component
    
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red100
        view.makeRounded(with: 4)
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .body3m
        label.textColor = .red300
        label.textAlignment = .center
        return label
    }()
    
    private let evaluationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .label1
        label.textColor = .red500
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Interface
    
    var payload: Payload? {
        didSet { updateUI() }
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    
    private func configureUI() {
        addSubview(contentView)
        
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(categoryLabel)
        contentStackView.addArrangedSubview(evaluationLabel)
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(.spacing12)
            make.top.bottom.equalToSuperview().inset(.spacing4)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.bottom.equalToSuperview()
        }
        
        evaluationLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func updateUI() {
        guard let payload else { return }
        
        categoryLabel.text = payload.kind.name
        switch payload.state {
        case .good:
            evaluationLabel.text = payload.kind.goodStateText
        case .normal:
            evaluationLabel.text = payload.kind.normalStateText
        case .bad:
            evaluationLabel.text = payload.kind.badStateText
        }
    }
}
