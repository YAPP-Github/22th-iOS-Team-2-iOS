//
//  EventProductEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import Foundation

struct EventProductEntity: Decodable, ProductConvertable {
    let imageURL: URL
    let storeType: ConvenienceStore
    let updatedTime: String
    let name: String
    let price: String
    let originalPrice: String
    let eventType: EventTag?
    let description: String?
    let giftItem: GiftItemEntity?
    let isNew: Bool
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case storeType
        case updatedTime
        case name
        case price
        case originalPrice = "originPrice"
        case eventType
        case description
        case giftItem = "giftImage"
        case isNew
    }
}
