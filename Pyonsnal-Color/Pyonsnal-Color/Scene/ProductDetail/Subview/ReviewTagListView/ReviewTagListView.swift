//
//  ReviewTagListView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/29.
//

import UIKit
import SnapKit

final class ReviewTagListView: UIView {
    
    // MARK: - Declaration
    
    struct Payload {
        let taste: ReviewEvaluationState
        let quality: ReviewEvaluationState
        let valueForMoney: ReviewEvaluationState
    }
    
    // MARK: - UI Component
    
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    private let stackView: UIStackView = {
        let stackView: UIStackView = .init(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Interface
    
    var payload: Payload? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Initialier
    
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
        
        contentView.addSubview(stackView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateUI() {
        guard let payload else { return }
        
        stackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        var currentWidth: CGFloat = 0
        let targetEstimateSize = CGSize(width: 50, height: 30)
        
        let line1StackView = UIStackView()
        line1StackView.axis = .horizontal
        line1StackView.spacing = 8
        
        let tasteLabel = ReviewEvaluationLabelView()
        tasteLabel.payload = .init(kind: .taste, state: payload.taste)
        tasteLabel.frame = .init(origin: .zero, size: targetEstimateSize)
        tasteLabel.layoutIfNeeded()
        let tasteEstimateSize = tasteLabel.systemLayoutSizeFitting(targetEstimateSize)
        
        currentWidth += tasteEstimateSize.width
        currentWidth += 8
        line1StackView.addArrangedSubview(tasteLabel)
        
        let qualityLabel = ReviewEvaluationLabelView()
        qualityLabel.payload = .init(kind: .quality, state: payload.quality)
        qualityLabel.layoutIfNeeded()
        let qualityEstimateSize = qualityLabel.systemLayoutSizeFitting(targetEstimateSize)
        
        currentWidth += qualityEstimateSize.width
        currentWidth += 8
        line1StackView.addArrangedSubview(qualityLabel)
        
        let valueForMoneyLabel = ReviewEvaluationLabelView()
        valueForMoneyLabel.payload = .init(kind: .valueForMoney, state: payload.valueForMoney)
        valueForMoneyLabel.layoutIfNeeded()
        let valueEstimateSize = valueForMoneyLabel.systemLayoutSizeFitting(targetEstimateSize)
        layoutIfNeeded()
        if currentWidth + valueEstimateSize.width > bounds.width {
            let line2StackView = UIStackView()
            line2StackView.axis = .horizontal
            line2StackView.spacing = 8
            
            line2StackView.addArrangedSubview(valueForMoneyLabel)
            
            stackView.addArrangedSubview(line1StackView)
            stackView.addArrangedSubview(line2StackView)
        } else {
            line1StackView.addArrangedSubview(valueForMoneyLabel)
            stackView.addArrangedSubview(line1StackView)
        }
        
    }
}
