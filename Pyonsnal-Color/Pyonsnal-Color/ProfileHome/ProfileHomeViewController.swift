//
//  ProfileHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import UIKit
import Combine
import ModernRIBs
import SnapKit
import MessageUI

protocol ProfileHomePresentableListener: AnyObject {
    func didTapMyReview() // 내 리뷰
    func didTapProfileEditButton(memberInfo: MemberInfoEntity) // 프로파일 편집
    func didTapTeams(with settingInfo: SettingInfo) // 만든 사람들
    func didTapAccountSetting() // 계정 설정
}

final class ProfileHomeViewController: UIViewController,
                                       ProfileHomePresentable,
                                       ProfileHomeViewControllable {
    
    enum Section: String {
        case review // 리뷰
        case setting // 기타
    }
    
    enum Setting: Int, CaseIterable {
        case etc = 0
        case email
        case version
        case teams
        case account
        
        var title: String {
            switch self {
            case .etc: "기타"
            case .email: "1:1 문의"
            case .version: "버전정보"
            case .teams: "만든 사람들"
            case .account: "계정 설정"
            }
        }
    }
    
    enum Review: Int, CaseIterable {
        case review = 0
        case myReview // 내 리뷰
        
        var title: String {
            switch self {
            case .review:
                return "리뷰"
            case .myReview:
                return "내 리뷰"
            }
        }
    }
    
    weak var listener: ProfileHomePresentableListener?
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var memberInfo: MemberInfoEntity?
    private let sections: [Section] = [.review, .setting]
    private var reviews: [Review] = [.review, .myReview]
    private var settings: [Setting] = [.etc, .email, .version, .teams, .account]
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTableView()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "main_my"
        ])
    }
    
    func update(with memberInfo: MemberInfoEntity) {
        self.memberInfo = memberInfo
        if let profileImage = memberInfo.profileImage,
            let url = URL(string: profileImage) {
            viewHolder.profileImageView.setImage(with: url)
        }
        viewHolder.nickNameLabel.text = memberInfo.nickname
        if memberInfo.isGuest {
            settings.remove(at: Setting.account.rawValue)
            viewHolder.profileEditButton.setImage(.iconDetail, for: .normal)
        }
    }
    
    // MARK: - Private Method
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func bindActions() {
        viewHolder.profileEditButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self, let memberInfo else { return }
                self.listener?.didTapProfileEditButton(memberInfo: memberInfo)
            }.store(in: &cancellable)
        
        viewHolder.charactorLandingButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else { return }
                // TODO: Landing to charactor page
            }.store(in: &cancellable)
    }
    
    private func configureTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: ImageAssetKind.TabBar.myUnselected.image,
            selectedImage: ImageAssetKind.TabBar.mySelected.image
        )
    }
    
    private func showEmailReport() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["pallete@pyonsnalcolor.store"])
        DispatchQueue.main.async {
            self.present(mail, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileHomeViewController: UITableViewDataSource {
    private func isSectionIndex(with index: Int) -> Bool {
        return index == 0
    }
    
    private func isSubLabelToShow(section: Section, index: Int) -> Bool {
        return (section == .setting) && (index == Setting.version.rawValue)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .review:
            return reviews.count
        case .setting:
            return settings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
        
        let section = sections[indexPath.section]
        let isSectionIndex = isSectionIndex(with: indexPath.row)
        let isSubLabelToShow = isSubLabelToShow(section: section, index: indexPath.row)
        let title: String
        
        switch section {
        case .review:
            title = reviews[indexPath.row].title
        case .setting:
            title = settings[indexPath.row].title
        }
        cell.update(text: title, isSectionIndex: isSectionIndex)
        cell.setSubLabelHidden(isShow: isSubLabelToShow)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 48
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if !isSectionIndex(with: indexPath.row) {
            switch section {
            case .review:
                if indexPath.row == Review.myReview.rawValue {
                    listener?.didTapMyReview()
                }
            case .setting:
                if indexPath.row == Setting.email.rawValue {
                    showEmailReport()
                } else if indexPath.row == Setting.teams.rawValue {
                    let title = settings[indexPath.row].title
                    let settingInfo = SettingInfo(title: title, infoUrl: .teams)
                    listener?.didTapTeams(with: settingInfo)
                } else if indexPath.row == Setting.account.rawValue {
                    listener?.didTapAccountSetting()
                }
                
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ProfileHomeViewController: MFMailComposeViewControllerDelegate {
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
