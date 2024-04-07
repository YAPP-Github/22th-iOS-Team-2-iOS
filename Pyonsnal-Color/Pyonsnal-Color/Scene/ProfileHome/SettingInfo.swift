//
//  SettingInfo.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/12.
//

import Foundation

struct SettingInfo {
    let title: String
    
    var infoUrl: Setting?
    
    enum Setting: String {
        case teams
        var urlString: String? {
            switch self {
            case .teams:
                return ProfileUrl.team
            }
            
        }
    }
}
