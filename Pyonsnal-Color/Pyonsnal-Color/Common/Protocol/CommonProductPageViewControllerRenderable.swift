//
//  CommonProductPageViewControllerRenderable.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/09.
//

import Foundation

protocol CommonProductPageViewControllerRenderable: AnyObject {
    func updateSelectedStoreCell(index: Int)
    func didChangeStore(to store: ConvenienceStore)
    func didSelect(with brandProduct: any ProductConvertable)
    func deleteKeywordFilter(_ filter: FilterItemEntity)
    func didTapRefreshFilterButton()
    func didFinishUpdateSnapshot()
}
