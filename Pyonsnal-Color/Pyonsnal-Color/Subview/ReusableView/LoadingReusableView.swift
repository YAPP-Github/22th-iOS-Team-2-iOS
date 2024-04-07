//
//  LoadingReusableView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/23.
//

import UIKit

final class LoadingReusableView: UICollectionReusableView {
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initailzer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraint()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureView() {
        viewHolder.place(in: self)
    }
    
    private func configureConstraint() {
        viewHolder.configureConstraints(for: self)
    }
    
    private func configureUI() {
        viewHolder.indicatorView.startAnimating()
    }
}
