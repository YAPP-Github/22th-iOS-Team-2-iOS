//
//  EventBannerItemCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/11.
//

import UIKit
import SnapKit

protocol EventBannerItemCellDelegate: AnyObject {
    func didTapEventBannerCell(with imageUrl: String, store: ConvenienceStore)
}

final class EventBannerItemCell: UICollectionViewCell {
    
    weak var delegate: EventBannerItemCellDelegate?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with imageURLString: String) {
        guard let encodedURLString = imageURLString.encodedURLString,
           let url = URL(string: encodedURLString) else { return }
        viewHolder.eventImageView.setImage(with: url)
    }
    
    func setImageContentMode(with storeType: ConvenienceStore) {
        if storeType == .sevenEleven {
            viewHolder.eventImageView.contentMode = .scaleAspectFit
            return
        }
        viewHolder.eventImageView.contentMode = .scaleAspectFill
    }
}

extension EventBannerItemCell {
    class ViewHolder: ViewHolderable {
        let eventImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        func place(in view: UIView) {
            view.addSubview(eventImageView)
        }
        
        func configureConstraints(for view: UIView) {
            eventImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
