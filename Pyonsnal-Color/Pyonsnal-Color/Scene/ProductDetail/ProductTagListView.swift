//
//  ProductTagListView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import UIKit

final class ProductTagListView: UIView {
    // MARK: - Declaration
    struct Payload {
        let isNew: Bool
        let eventTags: EventTag?
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let labelScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView: UIStackView = .init(frame: .zero)
        stackView.spacing = .spacing8
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func updateUI() {
        guard let payload else { return }
        
        labelStackView.subviews.forEach { $0.removeFromSuperview() }
        if payload.isNew {
            let newTag = NewTagView(mode: .big)
            labelStackView.addArrangedSubview(newTag)
        }
        
        if let eventTag = payload.eventTags, let eventName = eventTag.name, !eventName.isEmpty {
            let eventTagBig = EventTagBigView(payload: .init(eventTag: eventTag))
            labelStackView.addArrangedSubview(eventTagBig)
        }
        
        isHidden = labelStackView.subviews.isEmpty
//        payload.eventTags.forEach {
//            let eventTagBig = EventTagBigView(payload: .init(eventTag: $0))
//            labelStackView.addArrangedSubview(eventTagBig)
//        }
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(labelScrollView)
        
        labelScrollView.addSubview(labelStackView)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.edges.equalToSuperview()
        }
        
        labelScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalToSuperview()
        }
    }
}
