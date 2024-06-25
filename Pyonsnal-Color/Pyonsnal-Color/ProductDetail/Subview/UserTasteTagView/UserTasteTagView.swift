//
//  UserTasteTagView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 5/27/24.
//

import UIKit
import SnapKit

final class UserTasteTagView: UIView {
    
    // MARK: Declaration
    struct Payload {
        // TODO: 추가 예정
    }
    
    // MARK: UI Component
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .red100
        view.makeRounded(with: 1)
        return view
    }()
    
    private let userTasteTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red500
        label.font = .body3r
        return label
    }()
    
    // MARK: Interface
    var payload: Payload? {
        didSet { updateView() }
    }
    
    // MARK: Initializer
    init() {
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(userTasteTagLabel)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        userTasteTagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(.spacing8)
            $0.trailing.equalToSuperview().inset(.spacing8)
            $0.height.equalTo(userTasteTagLabel.font.customLineHeight)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func updateView() {
    }
}
