//
//  FavoriteHomeViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/28.
//

import UIKit
import SnapKit

extension FavoriteHomeViewController {
    final class ViewHolder: ViewHolderable {
        
        let titleNavigationView: TitleNavigationView = {
            let view = TitleNavigationView()
            view.updateTitleLabel(with: Text.tabBarItem)
            return view
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            return stackView
        }()
        
        private let dividerView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray200
            return view
        }()
        
        private let productSubView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let productTabButton: UIButton = {
            let button = UIButton()
            button.setText(with: Text.productTab)
            button.backgroundColor = .white
            button.titleLabel?.font = .label1
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.gray400, for: .normal)
            return button
        }()
        
        private let eventSubView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let eventTabButton: UIButton = {
            let button = UIButton()
            button.setText(with: Text.eventTab)
            button.titleLabel?.font = .label1
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.gray400, for: .normal)
            return button
        }()
        
        let productUnderBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        let eventUnderBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        let pageViewController = FavoriteHomePageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        func place(in view: UIView) {
            view.addSubview(titleNavigationView)
            view.addSubview(stackView)
            view.addSubview(dividerView)
            stackView.addArrangedSubview(productSubView)
            stackView.addArrangedSubview(eventSubView)
            productSubView.addSubview(productTabButton)
            productSubView.addSubview(productUnderBarView)
            eventSubView.addSubview(eventTabButton)
            eventSubView.addSubview(eventUnderBarView)
            view.addSubview(pageViewController.view)
        }
        
        func configureConstraints(for view: UIView) {
            titleNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.height.equalTo(Size.headerViewHeight)
                $0.leading.trailing.equalToSuperview()
            }
            
            stackView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.top.equalTo(titleNavigationView.snp.bottom)
                $0.height.equalTo(Size.stackViewHeight)
            }
            
            dividerView.snp.makeConstraints { make in
                make.height.equalTo(Size.dividerViewHeight)
                make.bottom.equalTo(stackView.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }
            
            productTabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            eventTabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            productUnderBarView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.underBarHeight)
            }
            
            eventUnderBarView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.underBarHeight)
            }
            
            pageViewController.view.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }

    }

}
