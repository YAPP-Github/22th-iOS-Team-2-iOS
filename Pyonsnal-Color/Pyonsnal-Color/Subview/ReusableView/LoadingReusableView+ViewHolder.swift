//
//  LoadingReusableView+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/23.
//

import UIKit

extension LoadingReusableView {
    final class ViewHolder: ViewHolderable {
        // MARK: - UI Component
        let indicatorView: UIActivityIndicatorView = {
            let indicatorView = UIActivityIndicatorView()
            indicatorView.color = .gray500
            return indicatorView
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(indicatorView)
        }
        
        func configureConstraints(for view: UIView) {
            indicatorView.snp.makeConstraints { make in
                make.size.equalTo(44)
                make.center.equalToSuperview()
            }
        }
    }
}
