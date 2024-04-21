//
//  ProfileHomeSection.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import Foundation

enum ProfileHomeSection: String {
    case setting
}

enum ProfileHomeSettingItem: Int {
    case etc = 0
    case email
    case version
    case teams
    case account
    
    var title: String {
        switch self {
        case .etc: "기타"
        case .email: "1:1 문의"
        case .version: "버전정보"
        case .teams: "만든 사람들"
        case .account: "계정 설정"
        }
    }
    
    var isSubLabelToShow: Bool {
        return self == .version
    }
    
    var isSectionIndex: Bool {
        return self == .etc
    }
}
