//
//  StarRatingReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import Combine
import ModernRIBs

protocol StarRatingReviewPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapRatingButton(score: Int)
}

final class StarRatingReviewViewController: UIViewController,
                                            StarRatingReviewPresentable,
                                            StarRatingReviewViewControllable {

    weak var listener: StarRatingReviewPresentableListener?
    private let productDetail: ProductDetailEntity
    private let viewHolder = ViewHolder()
    private var cancellable = Set<AnyCancellable>()
    
    init(productDetail: ProductDetailEntity) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
        configureNavigationView()
        configureStarRatingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "select_star_review"
        ])
    }
    
    private func configureView() {
        view.backgroundColor = .white
        viewHolder.storeImageView.setImage(productDetail.storeType.storeIcon)
        viewHolder.productImageView.setImage(with: productDetail.imageURL)
        viewHolder.productNameLabel.text = productDetail.name
    }
    
    private func configureNavigationView() {
        viewHolder.backNavigationView.delegate = self
    }
    
    private func configureStarRatingView() {
        viewHolder.starRatingView.delegate = self
    }
}

extension StarRatingReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        logging(.closeScreen, parameter: [
            .screenName: "review"
        ])
        listener?.didTapBackButton()
    }
}

extension StarRatingReviewViewController: StarRatingViewDelegate {
    func didTapRatingButton(score: Int) {
        listener?.didTapRatingButton(score: score)
    }
}
