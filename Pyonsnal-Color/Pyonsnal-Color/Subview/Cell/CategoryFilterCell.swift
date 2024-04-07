//
//  CategoryFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit
import SnapKit

final class CategoryFilterCell: UICollectionViewCell {
    
    // MARK: - UI Component
    private let filterButton: FilterButton = {
        let button = FilterButton()
        return button
    }()
    
    private let sortButton: SortButton = {
        let button = SortButton()
        return button
    }()
    
    private var currentButton = UIButton()
    
    override func prepareForReuse() {
        currentButton.removeFromSuperview()
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    func configure(filter: FilterEntity?) {
        guard let filter else { return }
        self.setButton(with: filter)
    }
    
    func setButton(with filter: FilterEntity) {
        currentButton = filter.filterType == .sort ? sortButton : filterButton
        if currentButton == filterButton {
            filter.isSelected == true ? filterButton.setUISelected() : filterButton.setUIUnSelected()
        }
        currentButton.setText(with: filter.defaultText ?? filter.filterType.filterDefaultText)
        self.place(in: contentView, button: currentButton)
        self.configureConstraints(for: contentView, button: currentButton)
    }
    
    func place(in view: UIView, button: UIButton) {
        view.addSubview(button)
    }
    
    func configureConstraints(for view: UIView, button: UIButton) {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    } 
}
