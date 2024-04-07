//
//  ProductHomeViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/21.
//

import UIKit
import SnapKit

// MARK: - UI Component
extension ProductHomeViewController {
    
    final class ViewHolder: ViewHolderable {
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = false
            return scrollView
        }()
        
        private let contentView: UIView = {
            let view = UIView(frame: .zero)
            view.backgroundColor = .white
            return view
        }()
        
        let titleNavigationView = TitleNavigationView()
        
        let collectionStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.bounces = false
            return collectionView
        }()
        
        let storeCollectionViewSeparator: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray200
            return view
        }()
        
        let filterCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.bounces = false
            collectionView.layoutMargins = CommonProduct.Size.filterMargin
            return collectionView
        }()
        
        let productHomePageViewController: ProductHomePageViewController = .init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        func place(in view: UIView) {
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(contentView)
            
            contentView.addSubview(titleNavigationView)
            contentView.addSubview(storeCollectionViewSeparator)
            contentView.addSubview(collectionStackView)
            contentView.addSubview(productHomePageViewController.view)
            
            collectionStackView.addArrangedSubview(collectionView)
            collectionStackView.addArrangedSubview(filterCollectionView)
        }
        
        func configureConstraints(for view: UIView) {
            containerScrollView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
            
            titleNavigationView.snp.makeConstraints { make in
                make.height.equalTo(CommonProduct.Size.titleNavigationBarHeight)
                make.leading.trailing.top.equalToSuperview()
            }
            
            collectionStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(titleNavigationView.snp.bottom)
            }
            
            collectionView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.height.equalTo(CommonProduct.Size.storeHeight)
            }
            
            storeCollectionViewSeparator.snp.makeConstraints { make in
                make.height.equalTo(CommonProduct.Size.storeCollectionViewSeparatorHeight)
                make.bottom.equalTo(collectionView.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }
            
            filterCollectionView.snp.makeConstraints {
                $0.height.equalTo(CommonProduct.Size.filterHeight)
                $0.top.equalTo(storeCollectionViewSeparator.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            
            productHomePageViewController.view.snp.makeConstraints { make in
                make.top.equalTo(collectionStackView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}
