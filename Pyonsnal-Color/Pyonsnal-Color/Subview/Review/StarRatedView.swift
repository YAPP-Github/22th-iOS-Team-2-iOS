//
//  StarRatedView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/10/03.
//

import UIKit
import SnapKit

final class StarRatedView: UIView {
    
    // MARK: - Declaration
    
    struct Payload {
        let score: Double
    }
    
    private let totalCount: Int = 5
    private var starViews: [StarView] = []
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    // MARK: - Interface
    
    var payload: Payload? {
        didSet {
            guard let payload else { return }
            updateScore(to: payload.score)
        }
    }
    
    init(score: Double) {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
        configureStarViews()
        updateScore(to: score)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(stackView)
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureStarViews() {
        for index in 0..<totalCount {
            let starView = StarView(index: index, mode: .medium)
            starViews.append(starView)
            stackView.addArrangedSubview(starView)
        }
    }
    
    func updateScore(to score: Double) {
        for (index, starView) in starViews.enumerated() {
            if index < Int(score) {
                starView.setFilledStarImage()
            } else if index == Int(score) {
                let decimalPoint = score - Double(Int(score))
                starView.fillDecimalStar(to: decimalPoint)
            } else {
                starView.setStarImage()
            }
        }
    }
}
