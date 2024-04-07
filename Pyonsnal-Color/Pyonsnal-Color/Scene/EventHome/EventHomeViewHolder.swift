//
//  EventHomeViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/03.
//

import UIKit
import SnapKit

// MARK: - UI Component
extension EventHomeViewController {
    
    final class ViewHolder: ViewHolderable {
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.bounces = false
            return scrollView
        }()
        
        private let contentView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let titleNavigationView = TitleNavigationView()

        
        let collectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: flowLayout)
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
            collectionView.bounces = false
            collectionView.backgroundColor = .clear
            collectionView.layoutMargins = CommonProduct.Size.filterMargin
            return collectionView
        }()
        
        private let contentPageView: UIView = {
            let view = UIView()
            return view
        }()
        
        lazy var pageViewController = EventHomePageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        func place(in view: UIView) {
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(contentView)
            contentView.addSubview(titleNavigationView)
            contentView.addSubview(storeCollectionViewSeparator)
            contentView.addSubview(collectionView)
            contentView.addSubview(filterCollectionView)
            contentView.addSubview(contentPageView)
            contentPageView.addSubview(pageViewController.view)
        }
        
        func configureConstraints(for view: UIView) {
            containerScrollView.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalToSuperview()
            }
            
            titleNavigationView.snp.makeConstraints {
                $0.height.equalTo(CommonProduct.Size.titleNavigationBarHeight)
                $0.top.leading.trailing.equalToSuperview()
            }
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(titleNavigationView.snp.bottom)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(CommonProduct.Size.storeHeight)
            }
            
            storeCollectionViewSeparator.snp.makeConstraints { make in
                make.height.equalTo(CommonProduct.Size.storeCollectionViewSeparatorHeight)
                make.top.equalTo(collectionView.snp.bottom).inset(CommonProduct.Size.storeCollectionViewSeparatorHeight)
                make.leading.trailing.equalToSuperview()
            }
            
            filterCollectionView.snp.makeConstraints {
                $0.height.equalTo(CommonProduct.Size.filterHeight)
                $0.top.equalTo(storeCollectionViewSeparator.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            
            contentPageView.snp.makeConstraints {
                $0.top.equalTo(filterCollectionView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }

            pageViewController.view.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}
