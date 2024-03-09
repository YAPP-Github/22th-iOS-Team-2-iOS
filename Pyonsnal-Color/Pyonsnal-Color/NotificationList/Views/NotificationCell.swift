//
//  NotificationCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/28.
//

import UIKit
import SnapKit

final class NotificationCell: UITableViewCell {
    static let identifier: String = .init(describing: NotificationCell.self)
    
    let viewHolder: ViewHolder = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        viewHolder.containerStackView.makeRounded(with: 16)
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func updateCell(with notification: NotificationEntity) {
        viewHolder.descriptionLabel.text = notification.description
        viewHolder.dateLabel.text = notification.date
        viewHolder.categoryTagImageView.image = notification.image
    }
}

extension NotificationCell {
    enum Size {
        static let containerMargin: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let containerSpacing: CGFloat = 20
        
        static let innerStackViewSpacing: CGFloat = 4
    }
    
    final class ViewHolder: ViewHolderable {
        
        let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = Size.containerMargin
            stackView.alignment = .top
            stackView.spacing = Size.containerSpacing
            stackView.backgroundColor = .white
            stackView.makeRounded(with: 16)
            return stackView
        }()
        
        let categoryImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .blue
            imageView.makeRounded(with: 18)
            return imageView
        }()
        
        private let innerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.spacing = Size.innerStackViewSpacing
            return stackView
        }()
        
        let categoryTagImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.makeRounded(with: 13)
            return imageView
        }()
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = .body2r
            label.numberOfLines = 0
            return label
        }()
        
        let dateLabel: UILabel = {
            let label = UILabel()
            label.font = .body3r
            // TODO: color 적용
            label.textColor = .systemGray
            return label
        }()
        
        let spacingView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            view.addSubview(spacingView)
            
            containerStackView.addArrangedSubview(categoryImageView)
            containerStackView.addArrangedSubview(innerStackView)
            
            innerStackView.addArrangedSubview(categoryTagImageView)
            innerStackView.addArrangedSubview(descriptionLabel)
            innerStackView.addArrangedSubview(dateLabel)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view)
            }
            
            categoryImageView.snp.makeConstraints { make in
                make.width.equalTo(36)
                make.height.equalTo(36)
            }
            
            categoryTagImageView.snp.makeConstraints { make in
                make.width.equalTo(73)
                make.height.equalTo(26)
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(descriptionLabel.font.customLineHeight)
            }
            
            dateLabel.snp.makeConstraints { make in
                make.height.equalTo(dateLabel.font.customLineHeight)
            }
            
            spacingView.snp.makeConstraints { make in
                make.height.equalTo(12)
                make.top.equalTo(containerStackView.snp.bottom)
                make.leading.trailing.equalTo(containerStackView)
                make.bottom.equalToSuperview()
            }
        }
    }
}
