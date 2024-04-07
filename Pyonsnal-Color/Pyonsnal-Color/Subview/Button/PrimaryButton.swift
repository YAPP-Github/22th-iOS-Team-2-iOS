//
//  PrimaryButton.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/06.
//

import UIKit

final class PrimaryButton: UIButton {
    
    enum ButtonSelectable: RawRepresentable {
        typealias RawValue = Bool
        case disabled
        case enabled
        case normal
        
        init?(rawValue: Bool) {
            self = rawValue ? .enabled : .disabled
        }
        
        var rawValue: Bool {
            switch self {
            case .disabled:
                return false
            default:
                return true
            }
        }
        
        private var disabledAttributes: ButtonAttributes {
            ButtonAttributes(textColor: .white, backgroundColor: .gray300)
        }
        private var enableAttributes: ButtonAttributes {
            ButtonAttributes(textColor: .red500, backgroundColor: .black)
        }
        private var defaultAttributes: ButtonAttributes {
            ButtonAttributes(
                textColor: .black,
                backgroundColor: .white,
                borderWidth: 1,
                borderColor: .black
            )
        }
        
        var attributes: ButtonAttributes {
            switch self {
            case .disabled:
                return disabledAttributes
            case .enabled:
                return enableAttributes
            case .normal:
                return defaultAttributes
            }
        }
    }
    
    struct ButtonAttributes {
        var textColor: UIColor
        var backgroundColor: UIColor
        var borderWidth: CGFloat = 0
        var borderColor: UIColor = .clear
    }
    
    enum Size {
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Initializer
    init(state: ButtonSelectable) {
        super.init(frame: .zero)
        setState(with: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    func setState(with state: ButtonSelectable) {
        self.isEnabled = state.rawValue
        updateUI(attribute: state.attributes)
    }
    
    func updateUI(attribute: ButtonAttributes) {
        self.setTitleColor(attribute.textColor, for: .normal)
        self.backgroundColor = attribute.backgroundColor
        self.contentHorizontalAlignment = .center
        self.makeRounded(with: .spacing16)
        self.makeBorder(width: attribute.borderWidth, color: attribute.borderColor.cgColor)
    }
}
