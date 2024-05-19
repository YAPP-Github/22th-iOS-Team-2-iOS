//
//  MyDetailReviewViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import UIKit
import SnapKit

extension MyDetailReviewViewController {
    enum Text {
        static let navigationTitleView = "상세 리뷰"
    }
    
    enum Size {
        static let productInfoStackView: CGFloat = 146
        static let dividerHeight: CGFloat = 1
    }
    
    class ViewHolder: ViewHolderable {
        let backNavigationView: BackNavigationView = {
            let navigationView = BackNavigationView()
            navigationView.payload = .init(mode: .text)
            navigationView.setText(with: Text.navigationTitleView)
            return navigationView
        }()
        
        let productInfoStackView: ProductInfoStackView = {
            let infoStackView = ProductInfoStackView(mode: .taste)
            return infoStackView
        }()
        
        let dividerView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray200
            return view
        }()
        
        // TODO: 아무래도 scrollView ..??
        // TODO: productDetailReviewCell
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(productInfoStackView)
            view.addSubview(dividerView)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            productInfoStackView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.dividerHeight)
            }
            
            dividerView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing24)
                $0.trailing.equalToSuperview().inset(.spacing24)
                $0.height.equalTo(Size.dividerHeight)
            }
        }
    }
}
