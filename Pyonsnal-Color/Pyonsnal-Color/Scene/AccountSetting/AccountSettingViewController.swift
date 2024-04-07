//
//  AccountSettingViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs
import UIKit

protocol AccountSettingPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapDeleteAccountButton()
    func didTapUseSection(with subTerms: SubTerms)
    func didTapLogoutButton()
}

final class AccountSettingViewController: UIViewController,
                                          AccountSettingPresentable,
                                          AccountSettingViewControllable {
    enum Size {
        static let backButtonSize: CGFloat = 24
        static let secessionButtonBottom: CGFloat = 34
        static let headerViewHeight: CGFloat = 48
        static let cellHeight: CGFloat = 48
        static let rows: CGFloat = 2
        static var cellTotalHeight: CGFloat {
            return rows * cellHeight
        }
    }
    
    enum Index {
        static let use: Int = 0
        static let logout: Int = 1
    }
    
    weak var listener: AccountSettingPresentableListener?
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private let accountSettingData = ["서비스 이용 약관", "로그아웃"]
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTableView()
        configureUI()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "account_set"
        ])
    }
    
    //MARK: - Private Method
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
        viewHolder.deleteAccount.addTarget(
            self,
            action: #selector(didTapDeleteAccountButton),
            for: .touchUpInside
        )
    }
    
    private func configureUI() {
        viewHolder.backNavigationView.payload = .init(
            mode: .text,
            title: "계정 설정",
            iconImageKind: nil
        )
    }
    
    @objc
    private func didTapDeleteAccountButton() {
        logging(.withdrawalClick, parameter: [
            .count: "count"
        ])
        listener?.didTapDeleteAccountButton()
    }
}

extension AccountSettingViewController: BackNavigationViewDelegate {
    @objc func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension AccountSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Index.use {
            let title = accountSettingData[Index.use]
            let subTerms = SubTerms(title: title, type: .use)
            listener?.didTapUseSection(with: subTerms)
        } else if indexPath.row == Index.logout {
            listener?.didTapLogoutButton()
        }
    }
}

extension AccountSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
        let text = accountSettingData[indexPath.row]
        cell.update(text: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cellHeight
    }
    
    
}

//MARK: - UI Component
extension AccountSettingViewController {
    class ViewHolder: ViewHolderable {
        let backNavigationView: BackNavigationView = {
            let backNavigationView = BackNavigationView()
            return backNavigationView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "계정 설정"
            label.font = .title2
            return label
        }()
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.bounces = false
            return tableView
        }()
        
        let deleteAccount: UIButton = {
            let button = UIButton()
            button.addUnderLine(with: "회원 탈퇴",
                                color: .gray500,
                                font: .body2m)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(tableView)
            
            view.addSubview(deleteAccount)
        }
        
        func configureConstraints(for view: UIView) {
            
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.headerViewHeight)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(AccountSettingViewController.Size.cellTotalHeight)
            }
            
            deleteAccount.snp.makeConstraints {
                $0.leading.equalTo(16)
                $0.bottom.equalToSuperview().inset(Size.secessionButtonBottom)
            }
        }
        

    }
}
