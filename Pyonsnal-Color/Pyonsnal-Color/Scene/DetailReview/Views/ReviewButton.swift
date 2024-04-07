//
//  ReviewButton.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/16.
//

import UIKit
import SnapKit

final class ReviewButton: UIButton {
    
    struct Payload {
        let kind: ReviewEvaluationKind
        let state: ReviewEvaluationState
    }
    
    enum Constant {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
    }
    
    let index: Int
    
    var payload: Payload? {
        didSet { updateUI() }
    }
    
    init(index: Int) {
        self.index = index
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        makeRounded(with: Constant.cornerRadius)
        titleLabel?.font = .body3m
        setTitleColor(.gray400, for: .normal)
        setTitleColor(.white, for: .selected)
        setUnselectedState()
    }
    
    private func setUnselectedState() {
        makeBorder(width: Constant.borderWidth, color: UIColor.gray200.cgColor)
    }
    
    private func updateUI() {
        guard let payload else { return }
        
        switch payload.state {
        case .good:
            setTitle(payload.kind.goodStateText, for: .normal)
        case .normal:
            setTitle(payload.kind.normalStateText, for: .normal)
        case .bad:
            setTitle(payload.kind.badStateText, for: .normal)
        }
    }
}
