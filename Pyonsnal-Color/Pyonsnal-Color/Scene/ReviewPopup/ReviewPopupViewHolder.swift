//
//  ReviewPopupViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import SnapKit

extension ReviewPopupViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Constant {
                static let topBottomMargin: CGFloat = .spacing40
                static let leftRightMargin: CGFloat = .spacing20
                static let titleStackViewSpacing: CGFloat = .spacing8
                static let buttonStackViewSpacing: CGFloat = .spacing16
                static let popupWidth: CGFloat = 358
                static let popupHeight: CGFloat = 208
                static let buttonWidth: CGFloat = 151
                static let buttonHeight: CGFloat = 52
        }
        
        private let containerView: UIView = .init(frame: .zero)
        
        var popupView = PopupView(state: .normal)
        
        func place(in view: UIView) {
            view.addSubview(containerView)
            
            containerView.addSubview(popupView)
        }
        
        func configureConstraints(for view: UIView) {
            containerView.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
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
