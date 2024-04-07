//
//  DetailReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import UIKit
import Combine
import ModernRIBs

protocol DetailReviewPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapApplyButton()
}

final class DetailReviewViewController: UIViewController,
                                        DetailReviewPresentable,
                                        DetailReviewViewControllable {
    
    enum Constant {
        static let textViewPlaceholder: String = "상품에 대한 솔직한 의견을 알려주세요."
        
        static let storeIconHeight: CGFloat = 20
        static let imageUploadSize: CGSize = .init(width: 1080, height: 1080)
        static let imageUploadIcon: UIImage? = .init(systemName: "plus")
    }
    
    weak var listener: DetailReviewPresentableListener?
    private let viewHolder = ViewHolder()
    private let productDetail: ProductDetailEntity
    private var cancellable = Set<AnyCancellable>()
    private(set) var reviews: [ReviewEvaluationKind: ReviewEvaluationState] = [:]
    private(set) var score: Int
    private(set) var userReviewInput: UserReviewInput
    
    init(productDetail: ProductDetailEntity, score: Int, userReviewInput: UserReviewInput) {
        self.productDetail = productDetail
        self.score = score
        self.userReviewInput = userReviewInput
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
        configureDelegate()
        configureImageUploadButton()
        configureDeleteImageButton()
        configureApplyReviewButton()
        configureUserReviewInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "write_review"
        ])
    }
    
    private func configureView() {
        view.backgroundColor = .white
        viewHolder.detailReviewTextView.text = Constant.textViewPlaceholder
        viewHolder.productImageView.setImage(with: productDetail.imageURL)
        viewHolder.productNameLabel.text = productDetail.name
        setResizedStoreIcon(productDetail.storeType.storeIcon.image)
        updateStarRatedView(score: score)
        viewHolder.totalScrollView.addTapGesture(
            target: self,
            action: #selector(touchEventAction(_:))
        )
    }
    
    private func configureDelegate() {
        viewHolder.backNavigationView.delegate = self
        viewHolder.tasteReview.delegate = self
        viewHolder.qualityReview.delegate = self
        viewHolder.priceReview.delegate = self
        viewHolder.detailReviewTextView.delegate = self
    }
    
    private func setApplyReviewButton(state isSatisfy: Bool) {
        let state: PrimaryButton.ButtonSelectable = isSatisfy ? .enabled : .disabled
        viewHolder.applyReviewButton.setState(with: state)
    }
    
    private func isReviewAllSatisfy() -> Bool {
        if viewHolder.priceReview.hasSelected() && viewHolder.qualityReview.hasSelected() &&
            viewHolder.tasteReview.hasSelected() {
            return true
        }
        return false
    }
    
    private func configureImageUploadButton() {
        viewHolder.imageUploadButton
            .tapPublisher
            .sink { [weak self] in
                self?.showImageLibrary()
            }.store(in: &cancellable)
    }
    
    private func configureDeleteImageButton() {
        viewHolder.deleteImageButton
            .tapPublisher
            .sink { [weak self] in
                self?.deleteUploadedImage()
            }.store(in: &cancellable)
    }
    
    private func configureApplyReviewButton() {
        viewHolder.applyReviewButton
            .tapPublisher
            .sink { [weak self] in
                self?.listener?.didTapApplyButton()
            }.store(in: &cancellable)
    }
    
    private func configureUserReviewInput() {
        userReviewInput.reviews.forEach { (value, state) in
            switch value {
            case .quality:
                viewHolder.qualityReview.selectReviewButton(state)
            case .taste:
                viewHolder.tasteReview.selectReviewButton(state)
            case .valueForMoney:
                viewHolder.priceReview.selectReviewButton(state)
            }
        }
        
        if !userReviewInput.reviewContents.isEmpty {
            viewHolder.detailReviewTextView.text = userReviewInput.reviewContents
            viewHolder.detailReviewTextView.textColor = .black
        }
        
        if let image = userReviewInput.reviewImage {
            updateProductImage(image)
        }
    }
    
    private func showImageLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    private func updateProductImage(_ image: UIImage) {
        let resizedImage = image.resize(targetSize: Constant.imageUploadSize)
        viewHolder.imageUploadButton.setImage(resizedImage, for: .normal)
        viewHolder.deleteImageButton.isHidden = false
    }
    
    private func deleteUploadedImage() {
        viewHolder.imageUploadButton.setImage(Constant.imageUploadIcon, for: .normal)
        viewHolder.deleteImageButton.isHidden = true
    }
    
    private func updateStarRatedView(score: Int) {
        viewHolder.starRatedView.updateScore(to: Double(score))
    }
    
    private func setResizedStoreIcon(_ image: UIImage?) {
        viewHolder.storeImageView.image = image
        if let storeIcon = image {
            let ratio = storeIcon.size.width / storeIcon.size.height
            let newWidth = Constant.storeIconHeight * ratio
            
            viewHolder.storeImageView.snp.makeConstraints {
                $0.width.equalTo(newWidth)
            }
        }
    }
    
    @objc private func touchEventAction(_ tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func getReviewContents() -> String {
        guard var text = viewHolder.detailReviewTextView.text else { return String() }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text == Constant.textViewPlaceholder {
            return String()
        }
        return text
    }
    
    func getReviewImage() -> UIImage? {
        guard let image = viewHolder.imageUploadButton.imageView?.image,
              image != Constant.imageUploadIcon
        else {
            return nil
        }
        
        return image
    }
}

extension DetailReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constant.textViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Constant.textViewPlaceholder
            textView.textColor = .gray400
        }
    }
}

extension DetailReviewViewController: UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            updateProductImage(editedImage)
        }
        
        picker.dismiss(animated: true)
    }
}

extension DetailReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension DetailReviewViewController: SingleLineReviewDelegate {
    func didSelectReview(_ review: Review) {
        reviews[review.kind] = review.state
        
        let state = isReviewAllSatisfy()
        setApplyReviewButton(state: state)
    }
}
