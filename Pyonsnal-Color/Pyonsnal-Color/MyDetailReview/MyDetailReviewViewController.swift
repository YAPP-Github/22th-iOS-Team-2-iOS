//
//  MyDetailReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs
import UIKit

protocol MyDetailReviewPresentableListener: AnyObject {
    func didTapBackButton()
}

final class MyDetailReviewViewController: UIViewController,
                                          MyDetailReviewPresentable,
                                          MyDetailReviewViewControllable {

    weak var listener: MyDetailReviewPresentableListener?
    let viewHolder: ViewHolder = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        self.bindActions()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
    }
    
    
    private func bindActions() {
        self.viewHolder.backNavigationView.delegate = self
    }
    
}

extension MyDetailReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
