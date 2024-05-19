//
//  MyReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs
import UIKit

protocol MyReviewPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyReviewViewController: UIViewController, MyReviewPresentable, MyReviewViewControllable {

    weak var listener: MyReviewPresentableListener?
}
