//
//  BaseViewControllerPorotocol.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import UIKit

protocol BaseViewControllerPorotocol where Self: UIViewController {
    associatedtype ViewHolder: ViewHolderable
    associatedtype ViewModel: BaseViewModelProtocol
    
    var viewHolder: ViewHolder { get }
    var viewModel: ViewModel { get }
}

extension BaseViewControllerPorotocol {
    func viewHolderConfigure() {
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
    }
}

typealias BaseViewController = UIViewController & BaseViewControllerPorotocol
