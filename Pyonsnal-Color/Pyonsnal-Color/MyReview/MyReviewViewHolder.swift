//
//  MyReviewViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import UIKit

extension MyReviewViewController {
    enum Text {
        static let navigationTitleView = "내 리뷰"
    }
    
    class ViewHolder: ViewHolderable {
        let backNavigationView: BackNavigationView = {
            let navigationView = BackNavigationView()
            navigationView.payload = .init(mode: .text)
            navigationView.setText(with: Text.navigationTitleView)
            return navigationView
        }()
        
        let tableView: UITableView = {
            let tableView = UITableView()
            return tableView
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(tableView)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        
    }
}
