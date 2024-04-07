//
//  LoginPopupViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import ModernRIBs
import UIKit

protocol LoginPopupPresentableListener: AnyObject {
    func popupDidTapDismiss()
    func popupDidTapConfirm()
}

final class LoginPopupViewController: UIViewController, LoginPopupPresentable, LoginPopupViewControllable {

    enum Constant {
        static let popupTitle: String = "로그인이 필요한 기능입니다."
        static let popupDescription: String = "지금 바로 편스널컬러의 회원이 되어\n모든 기능을 이용해보세요!"
        static let dismissText: String = "닫기"
        static let confirmText: String = "로그인하기"
    }
    
    // MARK: Property
    private let viewHolder: ViewHolder = .init()
    
    weak var listener: LoginPopupPresentableListener?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configurePopupView()
    }
    
    private func configurePopupView() {
        viewHolder.popupView.delegate = self
        viewHolder.popupView.configurePopup(
            title: Constant.popupTitle,
            description: Constant.popupDescription,
            dismissText: Constant.dismissText,
            confirmText: Constant.confirmText
        )
    }
}

// MARK: - PopupViewDelegate
extension LoginPopupViewController: PopupViewDelegate {
    func didTapDismissButton() {
        listener?.popupDidTapDismiss()
    }
    
    func didTapConfirmButton() {
        listener?.popupDidTapConfirm()
    }
}
