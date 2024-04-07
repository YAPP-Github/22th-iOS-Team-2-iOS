//
//  GiftInformationView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit

final class GiftInformationView: UIView {
    // MARK: - Declaration
    
    struct Payload {
        let giftEntity: ProductGiftEntity
    }
    
    enum Constant {
        enum Text {
            static let principleLabelText: String = "증정 행사상품의 구매조건(수량 등)이 상이할 수 있으므로, 자세한 내용은 매장에서 확인해주세요"
        }
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let giftItemView: GiftItemView = {
        let giftItemView: GiftItemView = .init()
        return giftItemView
    }()
    
    private let principleLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.numberOfLines = 0
        label.font = .body3m
        label.textColor = .init(rgbHexString: "B3B3B6")
        label.text = Constant.Text.principleLabelText
        return label
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
        giftItemView.payload = .init(giftEntity: payload.giftEntity)
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(giftItemView)
        contentView.addSubview(principleLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        giftItemView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        principleLabel.snp.makeConstraints { make in
            make.top.equalTo(giftItemView.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
