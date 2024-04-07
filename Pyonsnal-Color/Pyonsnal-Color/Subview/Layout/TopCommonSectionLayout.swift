//
//  TopCommonSectionLayout.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/23.
//

import UIKit

final class TopCommonSectionLayout {
    
    enum ConvenienceStore {
        static let estimatedWidth: CGFloat = 56
        static let height: CGFloat = 44
    }
    
    enum Filter {
        static let estimatedWidth: CGFloat = 64
        static let cellHeight: CGFloat = 32
        static let height: CGFloat = 56
        static let interSpacing: CGFloat = 8
    }
    
    func convenienceStoreLayout(convenienceStore: [String]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(ConvenienceStore.estimatedWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(ConvenienceStore.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let cellConstant = ConvenienceStoreCell.Constant.Size.self
        let cellSizes = convenienceStore.reduce(
            CGFloat(0), { partialResult, title in
            let label: UILabel = {
                let label = UILabel()
                label.text = title
                label.font = cellConstant.font
                label.sizeToFit()
                return label
            }()
            return partialResult + label.bounds.width + cellConstant.padding.left * 2
        })
        let cellMargin = Spacing.spacing16.value * 2
        let cellWidth = UIScreen.main.bounds.width - cellMargin
        let cellInterCount = CGFloat(convenienceStore.count - 1)
        let interSpacing = floor((cellWidth - cellSizes) / cellInterCount)
        
        group.interItemSpacing = .fixed(interSpacing)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func filterLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Filter.estimatedWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Filter.estimatedWidth),
            heightDimension: .absolute(Filter.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Filter.interSpacing
        section.contentInsets = .init(
            top: .spacing12,
            leading: .spacing16,
            bottom: .spacing12,
            trailing: .spacing16
        )
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}
