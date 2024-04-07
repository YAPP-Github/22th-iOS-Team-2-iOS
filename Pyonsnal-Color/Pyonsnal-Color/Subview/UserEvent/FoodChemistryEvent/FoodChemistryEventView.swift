//
//  FoodChemistryEventView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/23/24.
//

import UIKit
import Combine
import SnapKit

// TODO: UserEventDelegate 같은걸로 변경예정
protocol FoodChemistryEventDelegate: AnyObject {
    func didSelectFoodResult(urlString: String)
}

final class FoodChemistryEventView: UIView {
    
    enum Constant {
        static let topOffset: CGFloat = 156
        static let bottomOffset: CGFloat = 627
        static let buttonOffset: CGFloat = 494
        static let buttonHeight: CGFloat = 52
        
        static var lineSpacing: CGFloat {
            70 * (itemSize.width / 110)
        }
        static let itemSpacing: CGFloat = 14
        static var itemSize: CGSize {
            let screenWidth = UIScreen.main.bounds.width
            let itemWidth = (screenWidth - 60) / 3
            return .init(width: itemWidth, height: itemWidth)
        }
    }
    
    private let links: [String]
    private var cancellable = Set<AnyCancellable>()
    
    weak var delegate: FoodChemistryEventDelegate?
    
    let foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    let foodTestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    init(links: [String]) {
        self.links = links
        super.init(frame: .zero)
        
        configureView()
        configureCollectionView()
        configureFoodTestButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        addSubview(foodCollectionView)
        addSubview(foodTestButton)
        
        foodCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constant.topOffset)
            $0.leading.equalToSuperview().offset(.spacing16)
            $0.trailing.equalToSuperview().inset(.spacing16)
            $0.bottom.equalToSuperview().inset(Constant.bottomOffset)
        }
        
        foodTestButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(.spacing16)
            $0.trailing.equalToSuperview().inset(.spacing16)
            $0.top.equalTo(foodCollectionView.snp.bottom).offset(Constant.buttonOffset)
            $0.height.equalTo(Constant.buttonHeight)
        }
    }
    
    private func configureCollectionView() {
        foodCollectionView.collectionViewLayout = createCollectionViewLayout()
        foodCollectionView.register(FoodChemistryCell.self)
        foodCollectionView.backgroundColor = .clear
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.lineSpacing
        layout.minimumInteritemSpacing = Constant.itemSpacing
        layout.itemSize = Constant.itemSize

        return layout
    }
    
    private func configureFoodTestButton() {
        foodTestButton
            .tapPublisher
            .sink { [weak self] in
                if let lastURL = self?.links.last {
                    self?.delegate?.didSelectFoodResult(urlString: lastURL)
                }
            }.store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDataSource
extension FoodChemistryEventView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return links.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FoodChemistryCell.identifier,
            for: indexPath
        ) as? FoodChemistryCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FoodChemistryEventView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard links.count > indexPath.item else { return }
        let url = links[indexPath.item]
        delegate?.didSelectFoodResult(urlString: url)
    }
}
