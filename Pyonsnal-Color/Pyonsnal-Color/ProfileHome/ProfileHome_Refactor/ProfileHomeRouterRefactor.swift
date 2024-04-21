//
//  ProfileHomeRouter_R.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import UIKit

class ProfileHomeRouterRefactor: BaseRouterProtocol {
    weak var viewController: UIViewController?
    
    func presentAccountSetting() {}
    
    func presentCommonWebView(title: String, url: String) {}
    
    func presentProfileEdit(memberInfo: MemberInfoEntity) {
    }
    
    func presentLoggedOut() {}
    
}
