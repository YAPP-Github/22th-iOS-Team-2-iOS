//
//  EventDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import UIKit
import ModernRIBs
import Kingfisher

protocol EventDetailPresentableListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailViewController: UIViewController,
                                       EventDetailPresentable,
                                       EventDetailViewControllable {

    weak var listener: EventDetailPresentableListener?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureUI()
        configureAction()
    }
    
    // MARK: - EventDetailPresentable
    func update(with imageURL: String, store: ConvenienceStore) {
        if let imageURL = URL(string: imageURL) {
            viewHolder.eventImageView.setImage(with: imageURL) { [weak self] in
                self?.viewHolder.updateImageViewHeight()
            }
        }
        viewHolder.backNavigationView.payload = .init(
            mode: .image,
            title: nil,
            iconImageKind: store.storeIconImage
        )
    }
    
    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
    }

}

// MARK: - ImageNavigationViewDelegate
extension EventDetailViewController: BackNavigationViewDelegate {
    @objc func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension EventDetailViewController {
    // MARK: - UI Component
    final class ViewHolder: ViewHolderable {
        let backNavigationView: BackNavigationView = {
            let backNavigationView = BackNavigationView()
            return backNavigationView
        }()
        
        private let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }()
        
        let eventImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(eventImageView)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            containerScrollView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
            eventImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
        }
        
        func updateImageViewHeight() {
            eventImageView.snp.makeConstraints {
                if let image = eventImageView.image {
                    let scale = image.size.width / eventImageView.bounds.width
                    $0.height.equalTo(image.size.height / scale)
                }
            }
        }
          
    }
}
