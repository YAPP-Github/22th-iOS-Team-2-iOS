//
//  TopCollectionViewDatasource.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/23.
//

import UIKit

class TopCollectionViewDatasource {
    enum SectionType: Hashable {
        case convenienceStore(store: [String])
    }
    
    enum ItemType: Hashable {
        case convenienceStore(storeName: String)
    }
    
    enum FilterSection: Hashable {
        case filter
    }
    
    enum FilterItem: Hashable {
        case filter(filterItem: FilterCellItem)
    }
    
    typealias StoreDataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    typealias FilterDataSource = UICollectionViewDiffableDataSource<FilterSection, FilterItem>
}
