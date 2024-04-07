//
//  CommonProductSectionLayout.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

final class CommonProductSectionLayout {
    
    enum Size {
        enum Event {
            static let width: CGFloat = 358
            static let height: CGFloat = 184
            static let inset: CGFloat = 16
        }
        
        enum Item {
            static let width: CGFloat = 171
            static let height: CGFloat = 235
            static let inset: CGFloat = 16
            static let bottomMargin: CGFloat = 42
            static let spacing: CGFloat = 12
        }
        
        enum Header {
            private static let topMargin: CGFloat = 24
            static let height: CGFloat = 32 + topMargin
        }
        
        enum KeywordFilter {
            static let estimatedWidth: CGFloat = 96
            static let height: CGFloat = 32
            static let interSpacing: CGFloat = 4
        }
        
        static let topMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 20
    }
    
    private func keywordFilterLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Size.KeywordFilter.estimatedWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Size.KeywordFilter.estimatedWidth),
            heightDimension: .absolute(Size.KeywordFilter.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Size.KeywordFilter.interSpacing
        section.contentInsets = .init(
            top: .spacing12,
            leading: .spacing16,
            bottom: 0,
            trailing: 0
        )
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func eventLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Event.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: Size.Event.inset,
                                                      bottom: 0,
                                                      trailing: Size.Event.inset)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: Size.topMargin,
                                                        leading: 0,
                                                        bottom: 0,
                                                        trailing: 0)
        section.boundarySupplementaryItems = createSupplementaryView()
        return section
    }
    
    private func itemLayout(isNeedHeaderView: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(Size.Item.width),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Item.height))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: Size.Item.inset,
                                                      bottom: 0,
                                                      trailing: Size.Item.inset)
        group.interItemSpacing = .fixed(Size.Item.spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Size.Item.spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: Size.topMargin,
                                                        leading: 0,
                                                        bottom: Size.Item.bottomMargin,
                                                        trailing: 0)
        if isNeedHeaderView {
            section.boundarySupplementaryItems = createSupplementaryView()
        }
        
        return section
    }
    
    private func emptyLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Header.height)),
            elementKind: ItemHeaderTitleView.className,
            alignment: .top
        )
        return [sectionHeader]
    }
}

extension CommonProductSectionLayout {

    // For Event
    func section(at type: EventHomeTabViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .keywordFilter:
            return keywordFilterLayout()
        case .event:
            return eventLayout()
        case .item(type: .empty):
            return emptyLayout()
        case .item(type: .item):
            return itemLayout(isNeedHeaderView: true)
        }
    }
    
    // For Home
    func section(at type: ProductListViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .keywordFilter:
            return keywordFilterLayout()
        case .product(type: .empty):
            return emptyLayout()
        case .product(type: .item):
            return itemLayout(isNeedHeaderView: true)
        }
    }
    
    // For Favorite
    func section(at type: FavoriteHomePageTabViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .product:
            return itemLayout(isNeedHeaderView: false)
        case .empty:
            return emptyLayout()
        }
    }

}
