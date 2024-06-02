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
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(collectionView)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}
