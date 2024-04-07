//
//  TermsOfUse.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import Foundation

struct SubTerms {
    let title: String
    var hasNextPage: Bool = false
    var type: TermsOfUse
    
    enum TermsOfUse {
        case age
        case use
        case privateInfo
        
        var urlString: String? {
            switch self {
            case .age:
                return nil
            case .use:
                return TermsOfUseUrl.use
            case .privateInfo:
                return TermsOfUseUrl.privateInfo
            }
        }
    }
}
