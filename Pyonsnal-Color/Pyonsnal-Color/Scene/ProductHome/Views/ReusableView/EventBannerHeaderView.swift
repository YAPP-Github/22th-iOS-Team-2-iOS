//
//  EventBannerHeaderView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 12/27/23.
//

import UIKit
import SnapKit

final class EventBannerHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderView(title: String) {
        titleLabel.text = title
    }
    
    private func configureLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(titleLabel.font.customLineHeight)
        }
    }
}
