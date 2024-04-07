//
//  NativeAdView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 12/24/23.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class NativeAdView: GADNativeAdView {
    
    private enum Size {
        static let iconSize: CGFloat = 34
    }
    
    private let viewHolder: ViewHolder = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
        bindViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViews() {
        headlineView = viewHolder.headlineLabel
        callToActionView = viewHolder.callToActionButton
        iconView = viewHolder.iconImageView
        bodyView = viewHolder.adDescriptionLabel
    }
    
    final class ViewHolder: ViewHolderable {
        let callToActionButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            return button
        }()
        
        let iconImageView: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()
        
        let headlineLabel: UILabel = {
            let label = UILabel()
            label.font = .label1
            return label
        }()
        
        let adDescriptionLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .body4r
            label.contentMode = .left
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(iconImageView)
            view.addSubview(headlineLabel)
            view.addSubview(adDescriptionLabel)
            view.addSubview(callToActionButton)
        }
        
        func configureConstraints(for view: UIView) {
            iconImageView.snp.makeConstraints { make in
                make.leading.top.equalToSuperview().offset(.spacing8)
                make.size.equalTo(Size.iconSize)
            }
            
            headlineLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(.spacing8)
                make.leading.equalTo(iconImageView.snp.trailing).offset(.spacing8)
                make.trailing.greaterThanOrEqualToSuperview().inset(.spacing8)
            }
            
            headlineLabel.snp.contentHuggingVerticalPriority = 250
            adDescriptionLabel.snp.contentHuggingVerticalPriority = 251
            
            adDescriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(headlineLabel.snp.bottom).offset(.spacing4)
                make.leading.equalTo(iconImageView.snp.trailing).offset(.spacing8)
                make.trailing.equalToSuperview().inset(.spacing12)
                make.bottom.equalToSuperview().inset(.spacing8)
            }
            
            callToActionButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
    }
    
}
