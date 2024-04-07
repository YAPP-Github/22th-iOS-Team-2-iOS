//
//  PopupViewDelegate.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import Foundation

protocol PopupViewDelegate: AnyObject {
    func didTapConfirmButton()
    func didTapDismissButton()
}
