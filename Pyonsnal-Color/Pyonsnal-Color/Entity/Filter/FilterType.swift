//
//  FilterType.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/25.
//

import Foundation

enum FilterType: Decodable {
    case sort // 정렬
    case recommend // 상품 추천
    case category // 카테고리
    case event // 행사
    // TODO: 상품 취향 필터 추가 예정
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try? container.decode(String.self)
        switch type {
        case "sort": self = .sort
        case "recommend": self = .recommend
        case "category": self = .category
        case "event": self = .event
        default: self = .unknown
        }
    }
    
    var filterDefaultText: String {
        switch self {
        case .sort:
            return "최신순"
        case .recommend:
            return "상품 추천"
        case .category:
            return "카테고리"
        case .event:
            return "행사"
        case .unknown:
            return ""
        }
    }
}
