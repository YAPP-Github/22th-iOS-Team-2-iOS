//
//  LoginPopupViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import UIKit
import SnapKit

extension LoginPopupViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Constant {
            static let popupHeight: CGFloat = 208
            
            static let backgroundColor: UIColor = .black.withAlphaComponent(0.4)
        }
        
        private let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = Constant.backgroundColor
            return view
        }()
        
        let popupView = PopupView(state: .normal)
        
        func place(in view: UIView) {
            view.addSubview(backgroundView)
            
            backgroundView.addSubview(popupView)
        }
        
        func configureConstraints(for view: UIView) {
            backgroundView.snp.makeConstraints {
                $0.edges.equalTo(view)
            }
            
            popupView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(Constant.popupHeight)
            }
        }
    }
}
