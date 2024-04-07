//
//  ViewHolable.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/10.
//

import UIKit

protocol ViewHolderable {
    func place(in view: UIView)
    func configureConstraints(for view: UIView)
}
