//
//  ProfileHomeViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import UIKit
import SnapKit

// MARK: - UI Component
extension ProfileHomeViewController {
    class ViewHolder: ViewHolderable {
        
        enum Size {
            static let profileImageViewSize: CGFloat = 40
            static let profileEditButtonSize: CGFloat = 48
            static let profileImageViewLeading: CGFloat = 17
            static let profileContainerViewHeight: CGFloat = 104
            static let charactorSlotViewHeight: CGFloat = 152
        }
        
        private let profileContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.makeRounded(with: Size.profileImageViewSize / 2)
            imageView.setImage(.tagStore)
            return imageView
        }()
        
        let nickNameLabel: UILabel = {
            let label = UILabel()
            label.font = .title2
            label.textColor = .black
            label.numberOfLines = 1
            return label
        }()
        
        let profileEditButton: UIButton = {
            let button = UIButton()
            button.setImage(ImageAssetKind.Profile.profileEdit.image, for: .normal)
            return button
        }()
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.bounces = false
            return tableView
        }()
        
        private let charactorSlotView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray100
            return view
        }()
        
        let charactorLandingButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .gray400
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(profileContainerView)
            profileContainerView.addSubview(profileImageView)
            profileContainerView.addSubview(nickNameLabel)
            profileContainerView.addSubview(profileEditButton)
            view.addSubview(charactorSlotView)
            charactorSlotView.addSubview(charactorLandingButton)
            view.addSubview(tableView)
        }
        
        func configureConstraints(for view: UIView) {
            profileContainerView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.profileContainerViewHeight)
            }
            
            profileImageView.snp.makeConstraints {
                $0.size.equalTo(Size.profileImageViewSize)
                $0.leading.equalToSuperview().offset(Size.profileImageViewLeading)
                $0.centerY.equalToSuperview()
            }
            
            nickNameLabel.snp.makeConstraints {
                $0.leading.equalTo(profileImageView.snp.trailing).offset(.spacing12)
                $0.centerY.equalTo(profileContainerView.snp.centerY)
                $0.trailing.greaterThanOrEqualTo(profileEditButton.snp.leading).inset(.spacing12)
            }
            
            profileEditButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(.spacing28)
                $0.trailing.equalToSuperview().inset(.spacing4)
                $0.size.equalTo(Size.profileEditButtonSize)
            }
            
            charactorSlotView.snp.makeConstraints {
                $0.top.equalTo(profileContainerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.charactorSlotViewHeight)
            }
            
            charactorLandingButton.snp.makeConstraints {
                $0.top.leading.equalToSuperview().offset(10)
                $0.trailing.bottom.equalToSuperview().inset(10)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(charactorSlotView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
        }
    }
}
