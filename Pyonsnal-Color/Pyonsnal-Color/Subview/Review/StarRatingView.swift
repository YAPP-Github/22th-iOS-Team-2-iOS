//
//  StarRatingView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/10/03.
//

import UIKit
import Combine
import SnapKit

protocol StarRatingViewDelegate: AnyObject {
    func didTapRatingButton(score: Int)
}

final class StarRatingView: UIView {
    private let totalCount: Int = 5
    private var starViews: [StarView] = []
    private var cancellable = Set<AnyCancellable>()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    weak var delegate: StarRatingViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
        configureStarViews()
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
            let starView = StarView(index: index, mode: .large)
            starViews.append(starView)
            stackView.addArrangedSubview(starView)
        }
        configureButtonAction()
    }
    
    private func configureButtonAction() {
        starViews.forEach { button in
            button
                .tapPublisher
                .sink { [weak self] in
                    let score = button.index + 1
                    
                    self?.didTapRatingButton(button)
                    self?.delegate?.didTapRatingButton(score: score)
                }.store(in: &cancellable)
        }
    }
    
    private func didTapRatingButton(_ sender: UIButton) {
        guard let starView = sender as? StarView else { return }
        let selectedIndex = starView.index
        
        for (index, starView) in starViews.enumerated() {
            if index <= selectedIndex {
                starView.setFilledStarImage()
            } else {
                starView.setStarImage()
            }
        }
    }
}
