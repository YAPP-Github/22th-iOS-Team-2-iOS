//
//  EventTagBigView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/07.
//

import UIKit
import SnapKit

final class EventTagBigView: UIView {
    // MARK: - Declaration
    enum Constant {
        enum Size {
            static let round4: CGFloat = 4
        }
    }
    
    struct Payload {
        let eventTag: EventTag
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .green500
        view.makeRounded(with: Constant.Size.round4)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.font = .body3m
        label.textColor = .white
        return label
    }()
    
    // MARK: - Interface
    var payload: Payload?
    
    // MARK: - Initializer
    init(payload: Payload?) {
        self.payload = payload
        
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureUI() {
        guard let payload else { return }
        
        titleLabel.text = payload.eventTag.name
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(.spacing2)
            make.leading.trailing.equalToSuperview().inset(.spacing10)
        }
    }
}
