//
//  ProductDetailSectionItem.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/17.
//

import Foundation

enum ProductDetailSectionItem {
    case image(imageURL: URL)
    case information(product: ProductDetailEntity)
    case reviewWrite(score: Double, reviewsCount: Int, sortItem: FilterItemEntity)
    case actionButton
    case review(productReview: ReviewEntity)
}
