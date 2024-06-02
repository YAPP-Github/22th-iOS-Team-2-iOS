//
//  EmptyCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/24.
//

import UIKit
import SnapKit

final class EmptyCell: UICollectionViewCell {
    
    // MARK: - Declaration
    enum Text {
        enum Search {
            static let titleLabelText = "앗! 원하는 검색 결과가 없어요."
            static let subtitleLabelText = "단어의 철자가 올바른지 한 번 더 확인해주세요."
        }
        
        enum Favorite {
            static let titleLabelText = "찜한 상품이 없습니다."
            static let subTitleLableText = "마음에 드는 상품의 하트를 눌러 저장해 보세요."
        }
    }
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(titleText: String, subTitleText: String) {
        viewHolder.titleLabel.text = titleText
        viewHolder.subtitleLabel.text = subTitleText
    }
    
    // MARK: - Private Method
    private func configureView() {
        viewHolder.place(in: contentView)
    }
    
    private func configureConstraint() {
        viewHolder.configureConstraints(for: contentView)
    }
}
