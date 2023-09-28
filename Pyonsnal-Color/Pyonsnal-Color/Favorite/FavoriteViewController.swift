//
//  FavoriteViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import UIKit
import SnapKit
import ModernRIBs
import Combine

protocol FavoritePresentableListener: AnyObject {
    func requestFavoriteProducts()
    func deleteAllProducts()
    func appendProduct(product: any ProductConvertable)
    func deleteProduct(product: any ProductConvertable)
    func didTapSearchButton()
    func didSelect(with product: any ProductConvertable)
    func loadMoreItems(type: ProductType)
    var isPagingEnabled: Bool { get }
}

enum FavoriteTab: Int, CaseIterable {
    case product = 0
    case event
    
    var productType: ProductType {
        switch self {
        case .product:
            return .pb
        case .event:
            return .event
        }
    }
}

final class FavoriteViewController: UIViewController,
                                    FavoritePresentable,
                                    FavoriteViewControllable {
    // MARK: Interface
    enum Size {
        static let headerViewHeight: CGFloat = 48
        static let stackViewHeight: CGFloat = 40
        static let underBarHeight: CGFloat = 3
        static let dividerViewHeight: CGFloat = 1
    }
    
    enum Text {
        static let tabBarItem = "찜"
        static let productTab = "차별화 상품"
        static let eventTab = "행사 상품"
    }
    
    weak var listener: FavoritePresentableListener?
    
    // MARK: Private Property
    private let viewHolder: ViewHolder = .init()
    private var products = [FavoriteTab: [any ProductConvertable]]()
    private var scrollIndex = CurrentValueSubject<Int, Never>(0)
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        listener?.requestFavoriteProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: self.view)
        viewHolder.configureConstraints(for: self.view)
        setTabSelectedState(to: .product)
        configureCollectionView()
        configureNavigationView()
        bindActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.deleteAllProducts()
    }
    
    // MARK: - Public Method
    func updateProducts(products: [any ProductConvertable], tab: FavoriteTab) {
        self.products[tab] = products
        viewHolder.collectionView.reloadData()
    }
    
    // MARK: - Private Method
    private func configureTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: Text.tabBarItem,
            image: ImageAssetKind.TabBar.favoriteUnSelected.image,
            selectedImage: ImageAssetKind.TabBar.favoriteSelected.image
        )
    }
    
    private func setTabSelectedState(to state: FavoriteTab) {
        switch state {
        case .product:
            setSelectedState(
                button: viewHolder.productTabButton,
                underBarView: viewHolder.productUnderBarView
            )
            setUnSelectedState(
                button: viewHolder.eventTabButton,
                underBarView: viewHolder.eventUnderBarView
            )
        case .event:
            setSelectedState(
                button: viewHolder.eventTabButton,
                underBarView: viewHolder.eventUnderBarView
            )
            setUnSelectedState(
                button: viewHolder.productTabButton,
                underBarView: viewHolder.productUnderBarView
            )
        }
    }
    
    private func setSelectedState(button: UIButton, underBarView: UIView) {
        button.isSelected = true
        underBarView.isHidden = false
    }
    
    private func setUnSelectedState(button: UIButton, underBarView: UIView) {
        button.isSelected = false
        underBarView.isHidden = true
    }
    
    private func didTapButton(selectedTab: FavoriteTab) {
        scrollIndex.send(selectedTab.rawValue)
        self.selectTabAndScrollToItem(tab: selectedTab)
    }
    
    private func selectTabAndScrollToItem(tab: FavoriteTab) {
        let indexPath = IndexPath(item: tab.rawValue, section: 0)
        viewHolder.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.register(FavoriteProductContainerCell.self)
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.dataSource = self
    }
    
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func bindActions() {
        viewHolder.productTabButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.didTapButton(selectedTab: .product)
            }.store(in: &cancellable)

        viewHolder.eventTabButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.didTapButton(selectedTab: .event)
            }.store(in: &cancellable)
        
        scrollIndex
            .sink { [weak self] index in
            let tab = FavoriteTab(rawValue: index) ?? .product
            self?.setTabSelectedState(to: tab)
        }.store(in: &cancellable)
        
    }

}

// MARK: - TitleNavigationViewDelegate
extension FavoriteViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
    }
}

// MARK: - ProductPresentable
extension FavoriteViewController: ProductPresentable {
    func didTabRootTabBar() {
        let cellIndexPath = IndexPath(item: scrollIndex.value, section: 0)
        guard let cell = viewHolder.collectionView.cellForItem(at: cellIndexPath) as? FavoriteProductContainerCell else { return }
        cell.scrollCollectionViewToTop()
    
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteTab.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteProductContainerCell = collectionView.dequeueReusableCell(for: indexPath)
        if products.isEmpty { return cell }
        guard let tab = FavoriteTab(rawValue: indexPath.item),
              let product = products[tab] else {
            return cell
        }
        cell.delegate = self
        cell.update(with: product)
        cell.endRefreshing()
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        scrollIndex.send(currentIndex)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// MARK: - FavoriteProductContainerCellDelegate
extension FavoriteViewController: FavoriteProductContainerCellDelegate {
    func didTapProduct(product: any ProductConvertable) {
        listener?.didSelect(with: product)
    }
    
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction) {
        switch action {
        case .add:
            listener?.appendProduct(product: product)
        case .delete:
            listener?.deleteProduct(product: product)
        }
    }
    
    func pullToRefresh() {
        listener?.deleteAllProducts()
    }
    
    func loadMoreItems() {
        if listener?.isPagingEnabled ?? false {
            let tab = FavoriteTab(rawValue: scrollIndex.value) ?? .product
            listener?.loadMoreItems(type: tab.productType)
        }
    }
}
