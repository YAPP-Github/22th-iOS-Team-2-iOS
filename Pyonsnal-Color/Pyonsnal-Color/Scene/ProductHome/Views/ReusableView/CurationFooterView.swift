//
//  CurationFooterView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/24.
//

import UIKit
import SnapKit

final class CurationFooterView: UICollectionReusableView {
    
    enum Size {
        static let footerHeight: CGFloat = 12
    }
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(dividerView)
        
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(Size.footerHeight)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isHidden = false
    }
}
