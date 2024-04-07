//
//  ProfileEditViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import UIKit
import Combine
import ModernRIBs
import PhotosUI

protocol ProfileEditPresentableListener: AnyObject {
    var isEditButtonEnabled: AnyPublisher<Bool, Never> { get }
    func didTapEditButton(with nickname: String, profileImage: UIImage?)
    func didTapBackButton()
    func editNickname(nickname: String?)
    func editProfileImage(image: UIImage?)
}

enum EditActionSheetSection: String {
    case camera = "카메라로 촬영하기"
    case gallery = "갤러리에서 선택하기"
    case delete = "프로필 사진 삭제"
    case cancel = "취소"
}

final class ProfileEditViewController: UIViewController,
                                       ProfileEditPresentable,
                                       ProfileEditViewControllable {

    weak var listener: ProfileEditPresentableListener?
    private var viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var maximumNicknameCount: Int = 15
    let imageUploadSize: CGSize = .init(width: 1080, height: 1080)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureUI()
        bindActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadInfo(with memberInfo: MemberInfoEntity?) {
        if let profileImage = memberInfo?.profileImage,
            let url = URL(string: profileImage) {
            viewHolder.profileImageView.setImage(with: url)
        }
        setNicknamePlaceHolder(nickname: memberInfo?.nickname)
    }
    
    func updateNicknameStatus(status: NetworkErrorType) {
        viewHolder.nicknameValidateLabel.text = status.rawValue
        viewHolder.nicknameValidateLabel.textColor = status.textColor
    }
    
    private func clearNicknameValidateLabel() {
        viewHolder.nicknameValidateLabel.text = ""
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func bindActions() {
        viewHolder.backNavigationView.delegate = self
        viewHolder.nicknameTextField.delegate = self
        viewHolder.imageContainerView
            .gesturePublisher()
            .sink { [weak self] _ in
                self?.showActionSheet()
            }.store(in: &cancellable)
        
        viewHolder.nicknameTextField
            .textPublisher
            .throttle(for: 0.2, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] text in
                guard let self, let text else { return }
                let isTextEmpty = text.isEmpty
                if isTextEmpty { clearNicknameValidateLabel() }
                self.listener?.editNickname(nickname: text)
                self.updateTextFieldBorderColor(isFilled: !isTextEmpty)
                self.updateNicknameCountLabel()
            }.store(in: &cancellable)
        
        viewHolder.editButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] in
                guard let self else { return }
                let nickname = getCurrentNickname()
                let profileImage = self.viewHolder.profileImageView.image
                self.listener?.didTapEditButton(with: nickname, profileImage: profileImage)
            }.store(in: &cancellable)
        
        listener?.isEditButtonEnabled
            .sink { [weak self] isValid in
                let validState = PrimaryButton.ButtonSelectable(rawValue: isValid) ?? .disabled
                self?.viewHolder.editButton.setState(with: validState)
            }.store(in: &cancellable)
            
    }
    
    private func setNicknamePlaceHolder(nickname: String?) {
        guard let nickname else { return }
        let placeHolderText = NSMutableAttributedString()
        placeHolderText.appendAttributes(string: nickname, font: .body2r, color: .gray400)
        viewHolder.nicknameTextField.attributedPlaceholder = placeHolderText
    }
    
    private func updateTextFieldBorderColor(isFilled: Bool) {
        let highlightColor: UIColor = isFilled ? .gray700 : .gray200
        viewHolder.nicknameTextField.makeBorder(width: 1, color: highlightColor.cgColor)
    }
    
    private func updateNicknameCountLabel() {
        let count = viewHolder.nicknameTextField.text?.count ?? 0
        viewHolder.nicknameCountLabel.text = "\(count)/\(Constant.maximumNicknameCount)"
    }
    
    private func getCurrentNickname() -> String {
        guard let nickname = viewHolder.nicknameTextField.text,
                !nickname.isEmpty else {
            return viewHolder.nicknameTextField.attributedPlaceholder?.string ?? ""
        }
        return nickname
    }
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: EditActionSheetSection.camera.rawValue, style: .default) { [weak self] _ in
            self?.showImagePicker()
        }
        let galleryAction = UIAlertAction(title: EditActionSheetSection.gallery.rawValue, style: .default) { [weak self] _ in
            self?.showPHPicker()
        }
        let deleteAction = UIAlertAction(title: EditActionSheetSection.delete.rawValue, style: .destructive) { [weak self] _ in
            self?.deleteProfileImage()
        }
        let cancelAction = UIAlertAction(title: EditActionSheetSection.cancel.rawValue, style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func deleteProfileImage() {
        viewHolder.profileImageView.setImage(.tagStore)
    }
}

// MARK: - BackNavigationViewDelegate
extension ProfileEditViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

// MARK: - UITextFieldDelegate
extension ProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if string.isBackSpace() { return true }
        if text.count >= Constant.maximumNicknameCount {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let resizedImage = editedImage.resize(targetSize: imageUploadSize)
            viewHolder.profileImageView.image = resizedImage
            listener?.editProfileImage(image: resizedImage)
        }
        
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.map(\.itemProvider).first else {
            return
        }
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self,
                      let image = image as? UIImage,
                      error == nil else { return }
                let resizedImage = image.resize(targetSize: imageUploadSize)
                DispatchQueue.main.async {
                    self.viewHolder.profileImageView.image = resizedImage
                    self.listener?.editProfileImage(image: resizedImage)
                }
            }
        }
    }
}
