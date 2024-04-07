//
//  CommonProductPageViewControllerRenderable.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/09.
//

import Foundation

protocol CommonProductPageViewControllerRenderable: FavoriteHomeDelegate {
    func updateSelectedStoreCell(index: Int)
    func didChangeStore(to store: ConvenienceStore)
    func didSelect(with brandProduct: ProductDetailEntity)
    func deleteKeywordFilter(_ filter: FilterItemEntity)
    func didTapRefreshFilterButton()
    func didFinishUpdateSnapshot()
}
