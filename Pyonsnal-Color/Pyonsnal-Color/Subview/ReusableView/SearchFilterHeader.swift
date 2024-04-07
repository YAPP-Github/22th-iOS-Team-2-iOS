//
//  SearchFilterHeader.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/29.
//

import UIKit

final class SearchFilterHeader: UICollectionReusableView {
    // MARK: - Declaration
    struct Payload {
        let totalCount: Int
        let filterItem: FilterItemEntity
    }
    enum Text {
        static let titleLabelText: String = "개의 상품이 있습니다."
    }
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var filterItem: FilterItemEntity?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraint()
        configureUI()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    weak var delegate: SearchFilterHeaderDelegate?
    
    func updateUI(payload: Payload) {
        let title = "\(payload.totalCount)\(Text.titleLabelText)"
        viewHolder.titleLabel.text = title
        viewHolder.sortButton.setTitle(payload.filterItem.name, for: .normal)
        filterItem = payload.filterItem
    }
    
    // MARK: - Private Method
    private func configureView() {
        viewHolder.place(in: self)
    }
    
    private func configureConstraint() {
        viewHolder.configureConstraints(for: self)
    }
    
    private func configureUI() {
    }
    
    private func configureAction() {
        viewHolder.sortButton.addTarget(
            self,
            action: #selector(sortButtonAction(_:)),
            for: .touchUpInside
        )
    }
    
    @objc private func sortButtonAction(_ sender: UIButton) {
        if let filterItem {
            delegate?.didTapSortButton(filterItem: filterItem)
        }
    }
}
