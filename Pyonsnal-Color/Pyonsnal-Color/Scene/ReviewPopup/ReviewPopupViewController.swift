//
//  ReviewPopupViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import Combine
import ModernRIBs

protocol ReviewPopupPresentableListener: AnyObject {
    func didTapDismissButton()
    func didTapApplyButton()
    func didTapBackButton()
}

final class ReviewPopupViewController: UIViewController, ReviewPopupPresentable, ReviewPopupViewControllable {
    enum Text {
        enum Cancel {
            static let title: String = "작성을 그만하시겠어요?"
            static let description: String = "작성 중인 내용은 저장되지 않습니다."
            static let dismiss: String = "그만하기"
            static let confirm: String = "계속하기"
        }

        enum Apply {
            static let title: String = "리뷰를 등록하시겠어요?"
            static let description: String = "등록 후 수정, 삭제가 되지 않습니다."
            static let dismiss: String = "돌아가기"
            static let confirm: String = "등록하기"
        }
    }
    
    weak var listener: ReviewPopupPresentableListener?
    
    private let viewHolder = ViewHolder()
    private var cancellable = Set<AnyCancellable>()
    
    convenience init(isApply: Bool) {
        self.init()
        
        configurePopupView(isApply: isApply)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
    }
    
    private func configurePopupView(isApply: Bool) {
        if isApply {
            viewHolder.popupView = .init(state: .normal)
            viewHolder.popupView.delegate = self
            viewHolder.popupView.configurePopup(
                title: Text.Apply.title,
                description: Text.Apply.description,
                dismissText: Text.Apply.dismiss,
                confirmText: Text.Apply.confirm
            )
        } else {
            viewHolder.popupView = .init(state: .reversed)
            viewHolder.popupView.delegate = self
            viewHolder.popupView.configurePopup(
                title: Text.Cancel.title,
                description: Text.Cancel.description,
                dismissText: Text.Cancel.confirm,
                confirmText: Text.Cancel.dismiss
            )
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
}

extension ReviewPopupViewController: PopupViewDelegate {
    func didTapDismissButton() {
        if viewHolder.popupView.state == .normal {
            listener?.didTapDismissButton()
        } else {
            listener?.didTapBackButton()
        }
    }
    
    func didTapConfirmButton() {
        if viewHolder.popupView.state == .normal {
            listener?.didTapApplyButton()
        } else {
            listener?.didTapDismissButton()
        }
    }
}
