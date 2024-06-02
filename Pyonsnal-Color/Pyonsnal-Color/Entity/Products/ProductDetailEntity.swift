//
//  ProductDetailEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/17.
//

import Foundation

struct ProductDetailEntity {
    let id: String
    let storeType: ConvenienceStore
    let imageURL: URL
    let name: String
    let price: String
    let eventType: EventTag?
    let productType: ProductType
    let updatedTime: String
    let description: String?
    let isNew: Bool?
    let viewCount: Int
    let category: String?
    let isFavorite: Bool?
    let originPrice: String?
    let giftImageURL: URL?
    let giftTitle: String?
    let giftPrice: String?
    let isEventExpired: Bool?
    var reviews: [ReviewEntity]
    let avgScore: Double?
}

extension ProductDetailEntity {
    var gift: ProductGiftEntity? {
        if let giftImageURL,
           let giftTitle,
           let giftPrice {
            return ProductGiftEntity(imageURL: giftImageURL, name: giftTitle, price: giftPrice)
        } else {
            return nil
        }
    }
}

extension ProductDetailEntity {
    func updateReviews(reviews: [ReviewEntity]) -> Self {
        return .init(
            id: self.id,
            storeType: self.storeType,
            imageURL: self.imageURL,
            name: self.name,
            price: self.price,
            eventType: self.eventType,
            productType: self.productType,
            updatedTime: self.updatedTime,
            description: self.description,
            isNew: self.isNew,
            viewCount: self.viewCount,
            category:
                self.category,
            isFavorite: self.isFavorite,
            originPrice: self.originPrice,
            giftImageURL: self.giftImageURL,
            giftTitle: self.giftTitle,
            giftPrice: self.giftPrice,
            isEventExpired: self.isEventExpired,
            reviews: reviews,
            avgScore: self.avgScore
        )
    }
}

extension ProductDetailEntity: Hashable {}

extension ProductDetailEntity: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case storeType
        case imageURL = "image"
        case name
        case price
        case eventType
        case productType
        case updatedTime
        case description
        case isNew
        case viewCount
        case category
        case isFavorite
        case originPrice
        case giftImageURL = "giftImage"
        case giftTitle
        case giftPrice
        case isEventExpired
        case reviews
        case avgScore
    }
}
