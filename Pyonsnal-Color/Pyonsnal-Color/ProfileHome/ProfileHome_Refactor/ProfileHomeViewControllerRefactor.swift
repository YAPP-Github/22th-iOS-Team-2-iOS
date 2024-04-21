//
//  ProfileHomeViewController_R.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import UIKit
import Combine
import MessageUI

final class ProfileHomeViewControllerRefactor: BaseViewController {
    
    // MARK: - Property
    let viewHolder: ViewHolder = .init()
    let viewModel: ProfileHomeViewModel
    
    // MARK: - Initializer
    init(viewModel: ProfileHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.configureConstraints(for: view)
        self.configureUI()
        self.configureTableView()
        self.bindActions()
        self.bindOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "main_my"
        ])
    }
    
    // MARK: Binding
    private func bindActions() {
        viewHolder.profileEditButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                self?.viewModel.send(.didTapProfileEditButton)
            }.store(in: &viewModel.cancellables)
    }
    
    private func bindOutputs() {
        viewModel.output.profileImage
            .sink { [weak self] image in
                self?.viewHolder.profileEditButton.setImage(image, for: .normal)
            }.store(in: &viewModel.cancellables)
        
        viewModel.output.memberInfo
            .sink { [weak self] memberInfo in
                guard let self else { return }
                if let profileImage = memberInfo.profileImage,
                    let url = URL(string: profileImage) {
                    viewHolder.profileImageView.setImage(with: url)
                }
                viewHolder.nickNameLabel.text = memberInfo.nickname
            }.store(in: &viewModel.cancellables)
    }
    
    // MARK: - Private Method
    private func configureTabBarItem() { // TODO: TabBarVC로 이동
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: ImageAssetKind.TabBar.myUnselected.image,
            selectedImage: ImageAssetKind.TabBar.mySelected.image
        )
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
    }
    
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func showEmailReport() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([viewModel.emailAddress])
        self.present(mail, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ProfileHomeViewControllerRefactor: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        let item = viewModel.settingItems[indexPath.row]
        switch section {
        case .setting:
            viewModel.send(.didSelectItem(item: item))
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileHomeViewControllerRefactor: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        switch section {
        case .setting:
            return viewModel.settingItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
        let section = viewModel.sections[indexPath.section]
        let item = viewModel.settingItems[indexPath.row]
        
        switch section {
        case .setting:
            cell.update(text: item.title,
                        isSectionIndex: item.isSectionIndex,
                        hasSubLabel: item.isSubLabelToShow)
        }
        return cell
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ProfileHomeViewControllerRefactor: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        DispatchQueue.main.async {
            controller.dismiss(animated: true)
        }
    }
}
