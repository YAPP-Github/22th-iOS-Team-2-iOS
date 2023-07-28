//
//  TitleNavigationView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/28.
//

import UIKit
import SnapKit

final class TitleNavigationView: UIView {
    
    enum Constant {
        enum Size {
            static let stackViewMargin: UIEdgeInsets = .init(
                top: 14,
                left: 20,
                bottom: 14,
                right: 20
            )
            static let indicatorWidth: CGFloat = 5
        }
        
        enum Text {
            static let font: UIFont = .title2
        }
    }
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.Size.stackViewMargin
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.setImage(.iconTitle)
        return imageView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(.iconSearch, for: .normal)
        button.tintColor = .gray700
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(.bellSimple, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let notificationIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.makeRounded(with: Constant.Size.indicatorWidth / 2)
        return view
    }()
    
    weak var delegate: TitleNavigationViewDelegate?
    
    convenience init() {
        self.init(frame: .zero)
        
        configureAction()
        configureLayout()
        configureConstraints()
        // TO DO : 알림 관련 작업시 해당 코드 삭제
        notificationButton.isHidden = true
    }
    
    private func configureAction() {
        searchButton.addTarget(
            self,
            action: #selector(didTabSearchButton),
            for: .touchUpInside
        )
        
        notificationButton.addTarget(
            self,
            action: #selector(didTabNotificationButton),
            for: .touchUpInside
        )
    }
    
    private func configureLayout() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(titleImageView)
        containerStackView.addArrangedSubview(searchButton)
        containerStackView.addArrangedSubview(notificationButton)
        
        notificationButton.addSubview(notificationIndicator)
    }
    
    private func configureConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        notificationIndicator.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(Constant.Size.indicatorWidth)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(.spacing24)
        }
    }
    
    @objc private func didTabSearchButton() {
        delegate?.didTabSearchButton()
    }
    
    @objc private func didTabNotificationButton() {
        delegate?.didTabNotificationButton()
    }
    
    func setImage(_ image: ImageAssetKind) {
        notificationButton.setImage(image, for: .normal)
    }
    
    func showNotificationIndicator(hasNotification: Bool) {
        notificationIndicator.isHidden = hasNotification ? false : true
    }
}
