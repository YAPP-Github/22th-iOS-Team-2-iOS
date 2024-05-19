//
//  MyReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs
import UIKit

protocol MyReviewPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyReviewViewController: UIViewController, MyReviewPresentable, MyReviewViewControllable {

    weak var listener: MyReviewPresentableListener?
    var viewHolder: MyReviewViewController.ViewHolder = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        self.configureUI()
        self.configureTableView()
    }
    
    func update(reviews: [ReviewEntity]) {
        self.updateNavigationTitle(reviewCount: reviews.count)
    }
    
    // MARK: - Private Mehods
    private func configureUI() {
        self.view.backgroundColor = .white
    }
    
    private func updateNavigationTitle(reviewCount: Int) {
        let updatedTitle = Text.navigationTitleView + "(\(reviewCount))"
        self.viewHolder.backNavigationView.setText(with: updatedTitle)
    }
    
    private func configureTableView() {
        self.viewHolder.tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: MyReviewContentView.identifier
        )
        self.viewHolder.tableView.delegate = self
        self.viewHolder.tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension MyReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: MyDetailReview
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension MyReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // TODO: interactor로부터 받아온 값으로 변경
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyReviewContentView.identifier, for: indexPath)
        cell.contentConfiguration = MyReviewContentConfiguration(
            storeImageIcon: .sevenEleven,
            imageUrl: "",
            title: "테스트",
            date: "2024.05.19"
        )
        return cell
    }
}
