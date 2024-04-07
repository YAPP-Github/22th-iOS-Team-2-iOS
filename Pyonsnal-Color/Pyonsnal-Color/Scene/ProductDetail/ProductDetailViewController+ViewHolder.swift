//
//  ProductDetailViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit
import SnapKit

extension ProductDetailViewController {
    final class ViewHolder: ViewHolderable {
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        let backNavigationView: BackNavigationView = {
            let backNavigationView = BackNavigationView()
            return backNavigationView
        }()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.refreshControl = .init()
            collectionView.register(ProductDetailImageCell.self)
            collectionView.register(ProductDetailInformationCell.self)
            collectionView.register(ProductDetailReviewWriteCell.self)
            collectionView.register(ProductDetailReviewCell.self)
            collectionView.registerFooterView(LineFooter.self)
            return collectionView
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(backNavigationView)
            contentView.addSubview(collectionView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            backNavigationView.snp.makeConstraints { make in
                make.leading.top.trailing.equalToSuperview()
            }
            
            collectionView.snp.makeConstraints { make in
                make.top.top.equalTo(backNavigationView.snp.bottom)
                make.leading.bottom.right.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}
