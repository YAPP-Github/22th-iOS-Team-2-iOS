//
//  CurationHeaderView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/24.
//

import UIKit
import SnapKit

final class CurationHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .body3r
        label.textColor = .gray500
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderView(with curation: CurationEntity) {
        titleLabel.text = curation.title
        descriptionLabel.text = curation.subTitle
    }
    
    private func configureLayout() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(titleLabel.font.customLineHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.spacing8.value)
            make.bottom.equalToSuperview()
            make.height.equalTo(descriptionLabel.font.customLineHeight)
        }
    }
}
