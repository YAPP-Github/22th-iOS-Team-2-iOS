//
//  LineFooter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

import SnapKit

final class LineFooter: UICollectionReusableView {
    
    // MARK: - UI Component
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    // MARK: - Initailzer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Method
    
    private func configureViews() {
        addSubview(contentView)
    }
    
    private func configureConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
