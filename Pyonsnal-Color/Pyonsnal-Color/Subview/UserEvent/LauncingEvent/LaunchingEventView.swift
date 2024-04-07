//
//  LaunchingEventView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/27/24.
//

import UIKit
import Combine
import SnapKit

final class LaunchingEventView: UIView {
    
    enum Constant {
        static let bottomOffset: CGFloat = 100
        static let buttonHeight: CGFloat = 52
    }
    
    private var cancellable = Set<AnyCancellable>()
    private let links: [String]
    
    weak var delegate: FoodChemistryEventDelegate?
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .spacing16
        return stackView
    }()
    
    private let foodTestButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .clear
        return button
    }()
    
    private let eventVerifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    init(links: [String]) {
        self.links = links
        super.init(frame: .zero)
        
        configureView()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(foodTestButton)
        containerStackView.addArrangedSubview(eventVerifyButton)
        
        containerStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(.spacing16)
            $0.trailing.equalToSuperview().inset(.spacing16)
            $0.bottom.equalToSuperview().inset(Constant.bottomOffset)
        }
        
        foodTestButton.snp.makeConstraints {
            $0.height.equalTo(Constant.buttonHeight)
        }
        
        eventVerifyButton.snp.makeConstraints {
            $0.height.equalTo(Constant.buttonHeight)
        }
    }
    
    private func configureButtons() {
        foodTestButton
            .tapPublisher
            .sink { [weak self] in
                guard let link = self?.links.first else { return }
                
                self?.delegate?.didSelectFoodResult(urlString: link)
            }.store(in: &cancellable)
        
        eventVerifyButton
            .tapPublisher
            .sink { [weak self] in
                guard let link = self?.links.last else { return }
                
                self?.delegate?.didSelectFoodResult(urlString: link)
            }.store(in: &cancellable)
    }
}
