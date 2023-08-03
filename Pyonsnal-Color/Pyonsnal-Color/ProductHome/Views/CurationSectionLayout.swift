//
//  CurationSectionLayout.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/27.
//

import UIKit

final class CurationSectionLayout {
    
    enum Size {
        static let cellHeight: CGFloat = 233
        static let imageHeight: CGFloat = 240
        static let headerHeight: CGFloat = 78
        static let footerHeight: CGFloat = 12
        static let spacing: CGFloat = Spacing.spacing12.value
        static let inset: NSDirectionalEdgeInsets = .init(
            top: Spacing.spacing40.value,
            leading: Spacing.spacing16.value,
            bottom: Spacing.spacing40.value,
            trailing: Spacing.spacing16.value
        )
    }
    
    private func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Size.imageHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createCurationSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.42),
            heightDimension: .estimated(Size.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = Size.spacing
        section.contentInsets = Size.inset
        section.boundarySupplementaryItems = createSupplementaryView()
        
        return section
    }
    
    private func createSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Size.headerHeight)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(UIScreen.main.bounds.width),
                heightDimension: .absolute(Size.footerHeight)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        return [sectionHeader, sectionFooter]
    }
}

extension CurationSectionLayout {
    func createSection(at section: ProductCurationViewController.Section) -> NSCollectionLayoutSection {
        switch section {
        case .image:
            return createImageSection()
        case .curation:
            return createCurationSection()
        }
    }
}
