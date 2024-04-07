//
//  SearchBarView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import UIKit
import SnapKit

final class SearchBarView: UIView {
    // MARK: - Declaration
    enum Constant {
        enum Size {
            static let searchRound: CGFloat = 16
            static let searchBorderWidth: CGFloat = 1
            static let searchBarHeight: CGFloat = 32
            static let searchIconSize: CGFloat = 16
            static let cancelButtonSize: CGFloat = 24
        }
        
        enum Text {
            static let searchPlaceholder: String = "검색어를 입력해주세요."
        }
    }
    
    // MARK: - Interface
    weak var delegate: SearchBarViewDelegate?
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let searchBackgroundView: UIView = {
        let view: UIView = UIView(frame: .zero)
        view.backgroundColor = .gray100
        view.makeRounded(with: Constant.Size.searchRound)
        view.makeBorder(width: Constant.Size.searchBorderWidth, color: UIColor.gray200.cgColor)
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init(frame: .zero)
        imageView.setImage(.iconSearch)
        imageView.tintColor = .gray700
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField: UITextField = .init(frame: .zero)
        textField.font = .body3r
        textField.textColor = .gray700
        textField.attributedPlaceholder = NSAttributedString(
            string: Constant.Text.searchPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray400
            ]
        )
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setImage(.iconDelete, for: .normal)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Private Property
    private var text: String? = nil {
        didSet {
            updateUI()
            delegate?.updateText(text)
        }
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
        configureUI()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func updateUI() {
        if let text {
            cancelButton.isHidden = text.isEmpty
        } else {
            cancelButton.isHidden = true
        }
    }
    
    private func configureUI() {
    }
    
    private func configureAction() {
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        
        cancelButton.addTarget(
            self,
            action: #selector(deleteButtonAction(_:)),
            for: .touchUpInside
        )
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(searchBackgroundView)
        
        searchBackgroundView.addSubview(iconImageView)
        searchBackgroundView.addSubview(textField)
        searchBackgroundView.addSubview(cancelButton)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(Constant.Size.searchBarHeight)
            make.edges.equalToSuperview()
        }
        
        searchBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.Size.searchIconSize)
            make.leading.equalToSuperview().offset(.spacing12)
            make.top.bottom.equalToSuperview().inset(.spacing8)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(.spacing12)
            make.top.bottom.equalToSuperview().inset(.spacing4)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.Size.cancelButtonSize)
            make.leading.equalTo(textField.snp.trailing).offset(.spacing8)
            make.top.bottom.equalToSuperview().inset(.spacing4)
            make.trailing.equalToSuperview().inset(.spacing8)
        }
    }
    
    @objc private func deleteButtonAction(_ sender: UIButton) {
        textField.text = nil
        text = nil
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        text = textField.text
    }
}
