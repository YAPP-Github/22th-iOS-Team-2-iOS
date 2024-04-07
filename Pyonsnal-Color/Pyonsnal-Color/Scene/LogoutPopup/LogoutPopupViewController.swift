//
//  LogoutPopupViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs
import SnapKit
import UIKit

protocol LogoutPopupPresentableListener: AnyObject {
    func didTapLogoutButton()
    func didTapDismissButton()
    func didTapDeleteAccountButton()
}

final class LogoutPopupViewController:
    UIViewController,
    LogoutPopupPresentable,
    LogoutPopupViewControllable {
    
    enum Text {
        enum Logout {
            static let title: String = "로그아웃 하시겠어요?"
            static let description: String = "다음에 또 편스널컬러를 찾아주세요!"
            static let dismissButtonText: String = "취소하기"
            static let confirmButtonText: String = "로그아웃 하기"
        }
        
        enum DeleteAccount {
            static let title: String = "정말 탈퇴하시겠어요?"
            static let description: String = "탈퇴하시면 앱 내 모든 데이터가 사라지게 돼요."
            static let dismissButtonText: String = "회원탈퇴"
            static let confirmButtonText: String = "취소하기"
        }
    }

    weak var listener: LogoutPopupPresentableListener?
        
    private let viewHolder: ViewHolder = .init()
    
    convenience init(isLogout: Bool) {
        self.init()

        configurePopupView(isLogout: isLogout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func configurePopupView(isLogout: Bool) {
        if isLogout {
            viewHolder.popupView = .init(state: .normal)
            viewHolder.popupView.delegate = self
            viewHolder.popupView.configurePopup(
                title: Text.Logout.title,
                description: Text.Logout.description,
                dismissText: Text.Logout.dismissButtonText,
                confirmText: Text.Logout.confirmButtonText
            )
        } else {
            viewHolder.popupView = .init(state: .reversed)
            viewHolder.popupView.delegate = self
            viewHolder.popupView.configurePopup(
                title: Text.DeleteAccount.title,
                description: Text.DeleteAccount.description,
                dismissText: Text.DeleteAccount.dismissButtonText,
                confirmText: Text.DeleteAccount.confirmButtonText
            )
        }
    }
}

extension LogoutPopupViewController: PopupViewDelegate {
    func didTapConfirmButton() {
        if viewHolder.popupView.state == .normal {
            listener?.didTapLogoutButton()
        } else {
            listener?.didTapDeleteAccountButton()
        }
    }
    
    func didTapDismissButton() {
        listener?.didTapDismissButton()
    }
}

extension LogoutPopupViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Constant {
            static let popupHeight: CGFloat = 208
        }
        
        private let containerView: UIView = .init(frame: .zero)
        
        var popupView: PopupView = .init(state: .normal)
        
        func place(in view: UIView) {
            view.addSubview(containerView)
            
            containerView.addSubview(popupView)
        }
        
        func configureConstraints(for view: UIView) {
            containerView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
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
